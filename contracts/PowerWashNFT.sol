// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title PowerWashNFT
 * @dev NFT contract for Power Wash Pro game skins and power-ups
 * Features:
 * - Multiple rarity levels (1-5)
 * - Boost multipliers for gameplay
 * - Royalty support (EIP-2981)
 * - Mintable by users (paid)
 * - Enumerable for easy querying
 */
contract PowerWashNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIdCounter;
    
    // ========== STRUCTS ==========
    
    struct SkinData {
        string name;
        uint256 rarity;          // 1=Common, 2=Rare, 3=Epic, 4=Legendary, 5=Mythic
        uint256 boostMultiplier; // Percentage boost (e.g., 25 = +25%)
        uint256 mintedAt;
    }
    
    // ========== STATE VARIABLES ==========
    
    mapping(uint256 => SkinData) public skins;
    
    // Prices per rarity (in wei)
    mapping(uint256 => uint256) public rarityPrices;
    
    // Royalty percentage (in basis points: 500 = 5%)
    uint256 public constant ROYALTY_PERCENTAGE = 500; // 5%
    
    // Base URI for metadata
    string private _baseTokenURI;
    
    // ========== EVENTS ==========
    
    event SkinMinted(
        address indexed owner,
        uint256 indexed tokenId,
        string name,
        uint256 rarity,
        uint256 boost
    );
    
    event PriceUpdated(uint256 indexed rarity, uint256 newPrice);
    event BaseURIUpdated(string newBaseURI);
    
    // ========== CONSTRUCTOR ==========
    
    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI
    ) ERC721(name, symbol) Ownable(msg.sender) {
        _baseTokenURI = baseURI;
        
        // Initialize default prices (in ETH)
        rarityPrices[1] = 0.01 ether;  // Common
        rarityPrices[2] = 0.05 ether;  // Rare
        rarityPrices[3] = 0.1 ether;   // Epic
        rarityPrices[4] = 0.5 ether;   // Legendary
        rarityPrices[5] = 1 ether;     // Mythic
    }
    
    // ========== MINTING FUNCTIONS ==========
    
    /**
     * @dev Mint a new NFT skin
     * @param name Name of the skin
     * @param rarity Rarity level (1-5)
     */
    function mint(string memory name, uint256 rarity) public payable returns (uint256) {
        require(rarity >= 1 && rarity <= 5, "Invalid rarity");
        require(msg.value >= rarityPrices[rarity], "Insufficient payment");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        // Calculate boost based on rarity
        uint256 boost = calculateBoost(rarity);
        
        // Create skin data
        skins[tokenId] = SkinData({
            name: name,
            rarity: rarity,
            boostMultiplier: boost,
            mintedAt: block.timestamp
        });
        
        // Mint NFT
        _safeMint(msg.sender, tokenId);
        
        emit SkinMinted(msg.sender, tokenId, name, rarity, boost);
        
        // Refund excess payment
        if (msg.value > rarityPrices[rarity]) {
            payable(msg.sender).transfer(msg.value - rarityPrices[rarity]);
        }
        
        return tokenId;
    }
    
    /**
     * @dev Batch mint multiple NFTs (for admin/promotions)
     */
    function mintBatch(
        address to,
        string[] memory names,
        uint256[] memory rarities
    ) public onlyOwner {
        require(names.length == rarities.length, "Arrays length mismatch");
        
        for (uint256 i = 0; i < names.length; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            
            uint256 boost = calculateBoost(rarities[i]);
            
            skins[tokenId] = SkinData({
                name: names[i],
                rarity: rarities[i],
                boostMultiplier: boost,
                mintedAt: block.timestamp
            });
            
            _safeMint(to, tokenId);
            
            emit SkinMinted(to, tokenId, names[i], rarities[i], boost);
        }
    }
    
    // ========== HELPER FUNCTIONS ==========
    
    /**
     * @dev Calculate boost multiplier based on rarity
     */
    function calculateBoost(uint256 rarity) public pure returns (uint256) {
        if (rarity == 1) return 10;   // Common: +10%
        if (rarity == 2) return 25;   // Rare: +25%
        if (rarity == 3) return 50;   // Epic: +50%
        if (rarity == 4) return 100;  // Legendary: +100%
        if (rarity == 5) return 200;  // Mythic: +200%
        return 0;
    }
    
    /**
     * @dev Get skin data for a token
     */
    function getSkinData(uint256 tokenId) public view returns (SkinData memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return skins[tokenId];
    }
    
    /**
     * @dev Get all NFTs owned by an address
     */
    function getOwnedTokens(address owner) public view returns (uint256[] memory) {
        uint256 balance = balanceOf(owner);
        uint256[] memory tokens = new uint256[](balance);
        
        for (uint256 i = 0; i < balance; i++) {
            tokens[i] = tokenOfOwnerByIndex(owner, i);
        }
        
        return tokens;
    }
    
    /**
     * @dev Get all NFTs owned by an address with their data
     */
    function getOwnedNFTsWithData(address owner) public view returns (
        uint256[] memory tokenIds,
        SkinData[] memory skinData
    ) {
        uint256 balance = balanceOf(owner);
        tokenIds = new uint256[](balance);
        skinData = new SkinData[](balance);
        
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            tokenIds[i] = tokenId;
            skinData[i] = skins[tokenId];
        }
        
        return (tokenIds, skinData);
    }
    
    // ========== ADMIN FUNCTIONS ==========
    
    /**
     * @dev Update price for a rarity level
     */
    function updateRarityPrice(uint256 rarity, uint256 newPrice) public onlyOwner {
        require(rarity >= 1 && rarity <= 5, "Invalid rarity");
        rarityPrices[rarity] = newPrice;
        emit PriceUpdated(rarity, newPrice);
    }
    
    /**
     * @dev Update base URI for metadata
     */
    function setBaseURI(string memory newBaseURI) public onlyOwner {
        _baseTokenURI = newBaseURI;
        emit BaseURIUpdated(newBaseURI);
    }
    
    /**
     * @dev Withdraw contract balance
     */
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner()).transfer(balance);
    }
    
    /**
     * @dev Emergency withdraw to specific address
     */
    function emergencyWithdraw(address payable to) public onlyOwner {
        require(to != address(0), "Invalid address");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        to.transfer(balance);
    }
    
    // ========== ROYALTY FUNCTIONS (EIP-2981) ==========
    
    /**
     * @dev Get royalty info for a token
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice) 
        external 
        view 
        returns (address receiver, uint256 royaltyAmount) 
    {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        receiver = owner();
        royaltyAmount = (salePrice * ROYALTY_PERCENTAGE) / 10000;
    }
    
    // ========== OVERRIDES ==========
    
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }
    
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return 
            interfaceId == 0x2a55205a || // EIP-2981 (Royalty)
            super.supportsInterface(interfaceId);
    }
    
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }
    
    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }
}
