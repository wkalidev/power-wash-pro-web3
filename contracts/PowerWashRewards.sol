// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

interface IWashToken {
    function rewardPlayer(address player, uint256 amount) external;
}

/**
 * @title PowerWashRewards
 * @dev Play-to-Earn reward system for Power Wash Pro
 * Features:
 * - Energy system (anti-farming)
 * - Score-based rewards
 * - Daily bonuses
 * - Anti-bot mechanics
 * - Achievement rewards
 */
contract PowerWashRewards is Ownable, ReentrancyGuard, Pausable {
    
    // ========== STRUCTS ==========
    
    struct PlayerStats {
        uint256 totalGames;
        uint256 totalScore;
        uint256 totalEarned;
        uint256 lastRewardTime;
        uint256 energyPoints;
        uint256 lastEnergyUpdate;
        uint256 level;
        bool isVerified;        // Manual verification for high earners
        uint256 joinedAt;
    }
    
    struct GameSession {
        uint256 score;
        uint256 playTime;      // in seconds
        uint256 level;
        uint256 timestamp;
        bool rewarded;
    }
    
    // ========== STATE VARIABLES ==========
    
    IWashToken public washToken;
    
    mapping(address => PlayerStats) public players;
    mapping(address => GameSession[]) public gameSessions;
    
    // Reward configuration
    uint256 public constant REWARD_PER_SCORE = 1e15;  // 0.001 WASH per score point
    uint256 public constant BONUS_PER_LEVEL = 100 * 1e18; // 100 WASH per level
    
    // Energy system
    uint256 public constant MAX_ENERGY = 100;
    uint256 public constant ENERGY_PER_GAME = 1;
    uint256 public constant ENERGY_REGEN_RATE = 1; // per 10 minutes
    uint256 public constant ENERGY_REGEN_INTERVAL = 10 minutes;
    
    // Anti-bot mechanics
    uint256 public constant MIN_PLAYTIME = 60; // 1 minute minimum
    uint256 public constant MAX_SCORE_PER_GAME = 100000;
    uint256 public constant COOLDOWN_BETWEEN_GAMES = 30; // seconds
    
    // Daily limits
    uint256 public constant MAX_GAMES_PER_DAY = 50;
    uint256 public constant MAX_REWARDS_PER_DAY = 10000 * 1e18; // 10,000 WASH
    
    mapping(address => uint256) public dailyGamesPlayed;
    mapping(address => uint256) public dailyRewardsEarned;
    mapping(address => uint256) public lastDayReset;
    
    // Achievements
    mapping(address => mapping(uint256 => bool)) public achievementsUnlocked;
    
    uint256 public totalPlayersCount;
    uint256 public totalRewardsDistributed;
    
    // ========== EVENTS ==========
    
    event GamePlayed(address indexed player, uint256 score, uint256 playTime);
    event RewardClaimed(address indexed player, uint256 amount, uint256 gameId);
    event EnergyRestored(address indexed player, uint256 amount);
    event AchievementUnlocked(address indexed player, uint256 achievementId, uint256 reward);
    event PlayerVerified(address indexed player);
    
    // ========== MODIFIERS ==========
    
    modifier resetDailyLimits(address player) {
        if (block.timestamp >= lastDayReset[player] + 1 days) {
            dailyGamesPlayed[player] = 0;
            dailyRewardsEarned[player] = 0;
            lastDayReset[player] = block.timestamp;
        }
        _;
    }
    
    // ========== CONSTRUCTOR ==========
    
    constructor(address _washToken) Ownable(msg.sender) {
        require(_washToken != address(0), "Invalid token address");
        washToken = IWashToken(_washToken);
    }
    
    // ========== GAME FUNCTIONS ==========
    
    /**
     * @dev Submit game result and claim reward
     */
    function claimReward(
        uint256 score,
        uint256 playTime,
        uint256 level
    ) external nonReentrant whenNotPaused resetDailyLimits(msg.sender) {
        PlayerStats storage player = players[msg.sender];
        
        // First time player
        if (player.joinedAt == 0) {
            player.joinedAt = block.timestamp;
            player.energyPoints = MAX_ENERGY;
            player.lastEnergyUpdate = block.timestamp;
            totalPlayersCount++;
        }
        
        // Regenerate energy
        _regenerateEnergy(msg.sender);
        
        // Validate game
        require(player.energyPoints >= ENERGY_PER_GAME, "No energy");
        require(playTime >= MIN_PLAYTIME, "Play time too short");
        require(score <= MAX_SCORE_PER_GAME, "Score too high");
        require(
            block.timestamp >= player.lastRewardTime + COOLDOWN_BETWEEN_GAMES,
            "Cooldown active"
        );
        require(dailyGamesPlayed[msg.sender] < MAX_GAMES_PER_DAY, "Daily limit reached");
        
        // Calculate reward
        uint256 reward = calculateReward(score, level, playTime, player.isVerified);
        
        require(
            dailyRewardsEarned[msg.sender] + reward <= MAX_REWARDS_PER_DAY,
            "Daily reward limit"
        );
        
        // Consume energy
        player.energyPoints -= ENERGY_PER_GAME;
        
        // Update stats
        player.totalGames++;
        player.totalScore += score;
        player.totalEarned += reward;
        player.lastRewardTime = block.timestamp;
        player.level = (player.totalGames / 10) + 1; // Level up every 10 games
        
        // Update daily stats
        dailyGamesPlayed[msg.sender]++;
        dailyRewardsEarned[msg.sender] += reward;
        
        // Record session
        gameSessions[msg.sender].push(GameSession({
            score: score,
            playTime: playTime,
            level: level,
            timestamp: block.timestamp,
            rewarded: true
        }));
        
        // Distribute reward
        washToken.rewardPlayer(msg.sender, reward);
        totalRewardsDistributed += reward;
        
        emit GamePlayed(msg.sender, score, playTime);
        emit RewardClaimed(msg.sender, reward, gameSessions[msg.sender].length - 1);
        
        // Check achievements
        _checkAchievements(msg.sender);
    }
    
    /**
     * @dev Calculate reward based on score and other factors
     */
    function calculateReward(
        uint256 score,
        uint256 level,
        uint256 playTime,
        bool isVerified
    ) public pure returns (uint256) {
        // Base reward from score
        uint256 baseReward = score * REWARD_PER_SCORE;
        
        // Level bonus
        uint256 levelBonus = level * BONUS_PER_LEVEL;
        
        // Time bonus (longer games = slight bonus)
        uint256 timeMultiplier = 100;
        if (playTime > 300) timeMultiplier = 110; // +10% for 5+ min games
        if (playTime > 600) timeMultiplier = 120; // +20% for 10+ min games
        
        uint256 reward = (baseReward + levelBonus) * timeMultiplier / 100;
        
        // Verified players get bonus
        if (isVerified) {
            reward = reward * 125 / 100; // +25% for verified
        }
        
        return reward;
    }
    
    // ========== ENERGY SYSTEM ==========
    
    /**
     * @dev Regenerate energy based on time passed
     */
    function _regenerateEnergy(address player) private {
        PlayerStats storage stats = players[player];
        
        if (stats.energyPoints >= MAX_ENERGY) {
            stats.lastEnergyUpdate = block.timestamp;
            return;
        }
        
        uint256 timePassed = block.timestamp - stats.lastEnergyUpdate;
        uint256 intervalsPasssed = timePassed / ENERGY_REGEN_INTERVAL;
        
        if (intervalsPasssed > 0) {
            uint256 energyToAdd = intervalsPasssed * ENERGY_REGEN_RATE;
            stats.energyPoints = _min(stats.energyPoints + energyToAdd, MAX_ENERGY);
            stats.lastEnergyUpdate = block.timestamp;
            
            emit EnergyRestored(player, energyToAdd);
        }
    }
    
    /**
     * @dev Manually trigger energy regeneration
     */
    function regenerateEnergy() external {
        _regenerateEnergy(msg.sender);
    }
    
    /**
     * @dev Get player's current energy (with regeneration calculated)
     */
    function getCurrentEnergy(address player) public view returns (uint256) {
        PlayerStats memory stats = players[player];
        
        if (stats.energyPoints >= MAX_ENERGY) {
            return MAX_ENERGY;
        }
        
        uint256 timePassed = block.timestamp - stats.lastEnergyUpdate;
        uint256 intervalsPasssed = timePassed / ENERGY_REGEN_INTERVAL;
        uint256 energyToAdd = intervalsPasssed * ENERGY_REGEN_RATE;
        
        return _min(stats.energyPoints + energyToAdd, MAX_ENERGY);
    }
    
    // ========== ACHIEVEMENTS ==========
    
    /**
     * @dev Check and unlock achievements
     */
    function _checkAchievements(address player) private {
        PlayerStats storage stats = players[player];
        
        // Achievement 1: Play 10 games
        if (stats.totalGames >= 10 && !achievementsUnlocked[player][1]) {
            _unlockAchievement(player, 1, 1000 * 1e18); // 1000 WASH
        }
        
        // Achievement 2: Earn 10,000 WASH
        if (stats.totalEarned >= 10000 * 1e18 && !achievementsUnlocked[player][2]) {
            _unlockAchievement(player, 2, 2000 * 1e18); // 2000 WASH
        }
        
        // Achievement 3: Reach level 10
        if (stats.level >= 10 && !achievementsUnlocked[player][3]) {
            _unlockAchievement(player, 3, 5000 * 1e18); // 5000 WASH
        }
        
        // Achievement 4: Score over 50k in one game
        GameSession[] storage sessions = gameSessions[player];
        if (sessions.length > 0 && 
            sessions[sessions.length - 1].score >= 50000 && 
            !achievementsUnlocked[player][4]) {
            _unlockAchievement(player, 4, 3000 * 1e18); // 3000 WASH
        }
    }
    
    /**
     * @dev Unlock achievement and reward player
     */
    function _unlockAchievement(address player, uint256 achievementId, uint256 reward) private {
        achievementsUnlocked[player][achievementId] = true;
        washToken.rewardPlayer(player, reward);
        players[player].totalEarned += reward;
        totalRewardsDistributed += reward;
        
        emit AchievementUnlocked(player, achievementId, reward);
    }
    
    // ========== ADMIN FUNCTIONS ==========
    
    /**
     * @dev Verify player (removes limits for trusted players)
     */
    function verifyPlayer(address player) external onlyOwner {
        require(players[player].joinedAt > 0, "Player not registered");
        players[player].isVerified = true;
        emit PlayerVerified(player);
    }
    
    /**
     * @dev Unverify player
     */
    function unverifyPlayer(address player) external onlyOwner {
        players[player].isVerified = false;
    }
    
    /**
     * @dev Restore energy (for promotions/events)
     */
    function adminRestoreEnergy(address player, uint256 amount) external onlyOwner {
        players[player].energyPoints = _min(
            players[player].energyPoints + amount,
            MAX_ENERGY
        );
    }
    
    /**
     * @dev Pause rewards
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Unpause rewards
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    // ========== VIEW FUNCTIONS ==========
    
    /**
     * @dev Get player stats
     */
    function getPlayerStats(address player) external view returns (
        uint256 totalGames,
        uint256 totalScore,
        uint256 totalEarned,
        uint256 currentEnergy,
        uint256 level,
        bool isVerified,
        uint256 gamesPlayedToday,
        uint256 rewardsEarnedToday
    ) {
        PlayerStats memory stats = players[player];
        
        // Reset daily if needed
        uint256 gamesPlayedTodayActual = dailyGamesPlayed[player];
        uint256 rewardsEarnedTodayActual = dailyRewardsEarned[player];
        
        if (block.timestamp >= lastDayReset[player] + 1 days) {
            gamesPlayedTodayActual = 0;
            rewardsEarnedTodayActual = 0;
        }
        
        return (
            stats.totalGames,
            stats.totalScore,
            stats.totalEarned,
            getCurrentEnergy(player),
            stats.level,
            stats.isVerified,
            gamesPlayedTodayActual,
            rewardsEarnedTodayActual
        );
    }
    
    /**
     * @dev Get pending reward for hypothetical game
     */
    function getPendingReward(
        uint256 score,
        uint256 playTime,
        uint256 level
    ) external view returns (uint256) {
        return calculateReward(score, level, playTime, players[msg.sender].isVerified);
    }
    
    /**
     * @dev Get total earned by address
     */
    function getTotalEarned(address player) external view returns (uint256) {
        return players[player].totalEarned;
    }
    
    /**
     * @dev Get game history
     */
    function getGameHistory(address player, uint256 limit) external view returns (
        GameSession[] memory
    ) {
        GameSession[] storage sessions = gameSessions[player];
        uint256 length = sessions.length > limit ? limit : sessions.length;
        
        GameSession[] memory recentSessions = new GameSession[](length);
        
        for (uint256 i = 0; i < length; i++) {
            recentSessions[i] = sessions[sessions.length - 1 - i];
        }
        
        return recentSessions;
    }
    
    /**
     * @dev Check if achievement is unlocked
     */
    function isAchievementUnlocked(address player, uint256 achievementId) 
        external 
        view 
        returns (bool) 
    {
        return achievementsUnlocked[player][achievementId];
    }
    
    // ========== UTILITY ==========
    
    function _min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }
}
