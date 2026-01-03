// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title WashToken
 * @dev $WASH token for Power Wash Pro ecosystem
 * Features:
 * - Play-to-Earn rewards
 * - Staking with APY rewards
 * - Burnable for power-ups
 * - Governance ready
 */
contract WashToken is ERC20, ERC20Burnable, Ownable, Pausable {
    
    // ========== STRUCTS ==========
    
    struct StakeInfo {
        uint256 amount;          // Amount staked
        uint256 startTime;       // When stake started
        uint256 lockDuration;    // Lock period in seconds
        uint256 rewardRate;      // APY in basis points (2500 = 25%)
    }
    
    // ========== STATE VARIABLES ==========
    
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18; // 1 billion tokens
    uint256 public constant INITIAL_SUPPLY = 400_000_000 * 10**18; // 40% for rewards
    
    // Staking state
    mapping(address => StakeInfo) public stakes;
    uint256 public totalStaked;
    
    // Authorized minters (game contracts)
    mapping(address => bool) public authorizedMinters;
    
    // Staking rates (in basis points: 2500 = 25% APY)
    uint256 public constant MIN_APY = 2000;  // 20% for short stakes
    uint256 public constant MAX_APY = 5000;  // 50% for 1 year stakes
    
    uint256 public constant MIN_LOCK_DURATION = 30 days;
    uint256 public constant MAX_LOCK_DURATION = 365 days;
    
    // ========== EVENTS ==========
    
    event Staked(address indexed user, uint256 amount, uint256 lockDays, uint256 rewardRate);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    event RewardClaimed(address indexed user, uint256 reward);
    event MinterAdded(address indexed minter);
    event MinterRemoved(address indexed minter);
    event PlayerRewarded(address indexed player, uint256 amount);
    
    // ========== MODIFIERS ==========
    
    modifier onlyMinter() {
        require(authorizedMinters[msg.sender] || msg.sender == owner(), "Not authorized minter");
        _;
    }
    
    // ========== CONSTRUCTOR ==========
    
    constructor() ERC20("Wash Token", "WASH") Ownable(msg.sender) {
        // Mint initial supply to owner for distribution
        _mint(msg.sender, INITIAL_SUPPLY);
    }
    
    // ========== STAKING FUNCTIONS ==========
    
    /**
     * @dev Stake tokens for rewards
     * @param amount Amount to stake
     * @param lockDays Number of days to lock (30-365)
     */
    function stake(uint256 amount, uint256 lockDays) external whenNotPaused {
        require(amount > 0, "Cannot stake 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(stakes[msg.sender].amount == 0, "Already staking");
        
        uint256 lockDuration = lockDays * 1 days;
        require(lockDuration >= MIN_LOCK_DURATION, "Lock too short");
        require(lockDuration <= MAX_LOCK_DURATION, "Lock too long");
        
        // Calculate APY based on lock duration
        uint256 rewardRate = calculateAPY(lockDuration);
        
        // Transfer tokens to contract
        _transfer(msg.sender, address(this), amount);
        
        // Create stake
        stakes[msg.sender] = StakeInfo({
            amount: amount,
            startTime: block.timestamp,
            lockDuration: lockDuration,
            rewardRate: rewardRate
        });
        
        totalStaked += amount;
        
        emit Staked(msg.sender, amount, lockDays, rewardRate);
    }
    
    /**
     * @dev Unstake tokens and claim rewards
     */
    function unstake() external {
        StakeInfo memory stakeInfo = stakes[msg.sender];
        require(stakeInfo.amount > 0, "No active stake");
        require(
            block.timestamp >= stakeInfo.startTime + stakeInfo.lockDuration,
            "Still locked"
        );
        
        uint256 reward = calculateReward(stakeInfo);
        uint256 total = stakeInfo.amount + reward;
        
        // Delete stake
        delete stakes[msg.sender];
        totalStaked -= stakeInfo.amount;
        
        // Mint rewards if needed
        if (totalSupply() + reward <= MAX_SUPPLY) {
            _mint(msg.sender, reward);
        }
        
        // Return staked amount
        _transfer(address(this), msg.sender, stakeInfo.amount);
        
        emit Unstaked(msg.sender, stakeInfo.amount, reward);
    }
    
    /**
     * @dev Emergency unstake (forfeits rewards)
     */
    function emergencyUnstake() external {
        StakeInfo memory stakeInfo = stakes[msg.sender];
        require(stakeInfo.amount > 0, "No active stake");
        
        uint256 amount = stakeInfo.amount;
        
        delete stakes[msg.sender];
        totalStaked -= amount;
        
        _transfer(address(this), msg.sender, amount);
        
        emit Unstaked(msg.sender, amount, 0);
    }
    
    /**
     * @dev Calculate reward for a stake
     */
    function calculateReward(StakeInfo memory stakeInfo) public view returns (uint256) {
        uint256 timeStaked = block.timestamp - stakeInfo.startTime;
        
        // Reward = principal * APY * time / year
        uint256 reward = (stakeInfo.amount * stakeInfo.rewardRate * timeStaked) / 
                        (10000 * 365 days);
        
        return reward;
    }
    
    /**
     * @dev Calculate pending reward for an address
     */
    function getPendingReward(address user) external view returns (uint256) {
        StakeInfo memory stakeInfo = stakes[user];
        if (stakeInfo.amount == 0) return 0;
        return calculateReward(stakeInfo);
    }
    
    /**
     * @dev Calculate APY based on lock duration
     */
    function calculateAPY(uint256 lockDuration) public pure returns (uint256) {
        if (lockDuration >= 365 days) return 5000; // 50% APY
        if (lockDuration >= 180 days) return 3500; // 35% APY
        if (lockDuration >= 90 days) return 2500;  // 25% APY
        return 2000; // 20% APY minimum
    }
    
    // ========== PLAY-TO-EARN FUNCTIONS ==========
    
    /**
     * @dev Reward a player (called by game contract)
     */
    function rewardPlayer(address player, uint256 amount) external onlyMinter {
        require(player != address(0), "Invalid player address");
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        
        _mint(player, amount);
        emit PlayerRewarded(player, amount);
    }
    
    /**
     * @dev Batch reward multiple players
     */
    function rewardPlayers(
        address[] calldata players,
        uint256[] calldata amounts
    ) external onlyMinter {
        require(players.length == amounts.length, "Arrays length mismatch");
        
        for (uint256 i = 0; i < players.length; i++) {
            require(players[i] != address(0), "Invalid player address");
            require(totalSupply() + amounts[i] <= MAX_SUPPLY, "Max supply exceeded");
            
            _mint(players[i], amounts[i]);
            emit PlayerRewarded(players[i], amounts[i]);
        }
    }
    
    // ========== ADMIN FUNCTIONS ==========
    
    /**
     * @dev Add authorized minter
     */
    function addMinter(address minter) external onlyOwner {
        require(minter != address(0), "Invalid address");
        authorizedMinters[minter] = true;
        emit MinterAdded(minter);
    }
    
    /**
     * @dev Remove authorized minter
     */
    function removeMinter(address minter) external onlyOwner {
        authorizedMinters[minter] = false;
        emit MinterRemoved(minter);
    }
    
    /**
     * @dev Pause token transfers
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Unpause token transfers
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    /**
     * @dev Mint tokens (only owner, for liquidity/marketing)
     */
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }
    
    // ========== VIEW FUNCTIONS ==========
    
    /**
     * @dev Get stake info for an address
     */
    function getStakeInfo(address user) external view returns (
        uint256 amount,
        uint256 startTime,
        uint256 lockDuration,
        uint256 rewardRate,
        uint256 unlockTime,
        uint256 pendingReward,
        bool isLocked
    ) {
        StakeInfo memory stakeInfo = stakes[user];
        
        amount = stakeInfo.amount;
        startTime = stakeInfo.startTime;
        lockDuration = stakeInfo.lockDuration;
        rewardRate = stakeInfo.rewardRate;
        unlockTime = stakeInfo.startTime + stakeInfo.lockDuration;
        pendingReward = calculateReward(stakeInfo);
        isLocked = block.timestamp < unlockTime;
    }
    
    /**
     * @dev Check if address is authorized minter
     */
    function isMinter(address account) external view returns (bool) {
        return authorizedMinters[account] || account == owner();
    }
    
    // ========== OVERRIDES ==========
    
    function _update(address from, address to, uint256 amount)
        internal
        override
        whenNotPaused
    {
        super._update(from, to, amount);
    }
    
    // ========== UTILITY FUNCTIONS ==========
    
    /**
     * @dev Get total value locked (TVL)
     */
    function getTVL() external view returns (uint256) {
        return totalStaked;
    }
    
    /**
     * @dev Get circulating supply (total - staked)
     */
    function getCirculatingSupply() external view returns (uint256) {
        return totalSupply() - totalStaked;
    }
}
