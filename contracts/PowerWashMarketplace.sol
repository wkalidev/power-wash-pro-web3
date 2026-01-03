// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title PowerWashMarketplace
 * @dev Marketplace for Power Wash Pro NFTs
 * Features:
 * - Buy/Sell NFTs
 * - Rent NFTs temporarily
 * - Auction system
 * - Platform fees
 */
contract PowerWashMarketplace is Ownable, ReentrancyGuard, Pausable {
    
    // ========== STRUCTS ==========
    
    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price;
        bool isActive;
        uint256 listedAt;
    }
    
    struct Rental {
        address owner;
        address renter;
        uint256 tokenId;
        uint256 pricePerDay;
        uint256 startTime;
        uint256 endTime;
        bool isActive;
    }
    
    struct Auction {
        address seller;
        uint256 tokenId;
        uint256 startPrice;
        uint256 highestBid;
        address highestBidder;
        uint256 endTime;
        bool isActive;
    }
    
    // ========== STATE VARIABLES ==========
    
    IERC721 public nftContract;
    
    // Listings: tokenId => Listing
    mapping(uint256 => Listing) public listings;
    
    // Rentals: tokenId => Rental
    mapping(uint256 => Rental) public rentals;
    
    // Auctions: tokenId => Auction
    mapping(uint256 => Auction) public auctions;
    
    // Platform fee (in basis points: 250 = 2.5%)
    uint256 public platformFee = 250; // 2.5%
    uint256 public rentalFee = 1000;  // 10%
    
    uint256 public constant MAX_FEE = 1000; // 10% max
    
    // Total volume traded
    uint256 public totalVolume;
    
    // ========== EVENTS ==========
    
    event Listed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event Unlisted(uint256 indexed tokenId, address indexed seller);
    event Sold(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);
    
    event Rented(uint256 indexed tokenId, address indexed renter, uint256 days, uint256 totalPrice);
    event RentalEnded(uint256 indexed tokenId, address indexed renter);
    
    event AuctionCreated(uint256 indexed tokenId, address indexed seller, uint256 startPrice, uint256 endTime);
    event BidPlaced(uint256 indexed tokenId, address indexed bidder, uint256 amount);
    event AuctionEnded(uint256 indexed tokenId, address indexed winner, uint256 finalPrice);
    
    event FeeUpdated(uint256 newFee);
    
    // ========== CONSTRUCTOR ==========
    
    constructor(address _nftContract) Ownable(msg.sender) {
        require(_nftContract != address(0), "Invalid NFT contract");
        nftContract = IERC721(_nftContract);
    }
    
    // ========== LISTING FUNCTIONS ==========
    
    /**
     * @dev List NFT for sale
     */
    function list(uint256 tokenId, uint256 price) external whenNotPaused {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Price must be > 0");
        require(!listings[tokenId].isActive, "Already listed");
        require(!rentals[tokenId].isActive, "Currently rented");
        
        listings[tokenId] = Listing({
            seller: msg.sender,
            tokenId: tokenId,
            price: price,
            isActive: true,
            listedAt: block.timestamp
        });
        
        emit Listed(tokenId, msg.sender, price);
    }
    
    /**
     * @dev Unlist NFT
     */
    function unlist(uint256 tokenId) external {
        Listing storage listing = listings[tokenId];
        require(listing.seller == msg.sender, "Not seller");
        require(listing.isActive, "Not listed");
        
        listing.isActive = false;
        
        emit Unlisted(tokenId, msg.sender);
    }
    
    /**
     * @dev Buy listed NFT
     */
    function buy(uint256 tokenId) external payable nonReentrant whenNotPaused {
        Listing storage listing = listings[tokenId];
        require(listing.isActive, "Not for sale");
        require(msg.value >= listing.price, "Insufficient payment");
        
        address seller = listing.seller;
        uint256 price = listing.price;
        
        // Calculate fees
        uint256 fee = (price * platformFee) / 10000;
        uint256 sellerAmount = price - fee;
        
        // Mark as sold
        listing.isActive = false;
        
        // Transfer NFT
        nftContract.transferFrom(seller, msg.sender, tokenId);
        
        // Transfer funds
        payable(seller).transfer(sellerAmount);
        // Platform fee stays in contract
        
        // Update volume
        totalVolume += price;
        
        emit Sold(tokenId, msg.sender, seller, price);
        
        // Refund excess
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
    }
    
    // ========== RENTAL FUNCTIONS ==========
    
    /**
     * @dev List NFT for rent
     */
    function listForRent(uint256 tokenId, uint256 pricePerDay) external whenNotPaused {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not owner");
        require(pricePerDay > 0, "Price must be > 0");
        require(!rentals[tokenId].isActive, "Already rented");
        require(!listings[tokenId].isActive, "Listed for sale");
        
        rentals[tokenId] = Rental({
            owner: msg.sender,
            renter: address(0),
            tokenId: tokenId,
            pricePerDay: pricePerDay,
            startTime: 0,
            endTime: 0,
            isActive: false
        });
    }
    
    /**
     * @dev Rent an NFT
     */
    function rent(uint256 tokenId, uint256 days) external payable nonReentrant whenNotPaused {
        Rental storage rental = rentals[tokenId];
        require(rental.owner != address(0), "Not available for rent");
        require(!rental.isActive, "Already rented");
        require(days > 0, "Must rent for at least 1 day");
        
        uint256 totalPrice = rental.pricePerDay * days;
        require(msg.value >= totalPrice, "Insufficient payment");
        
        // Calculate fee
        uint256 fee = (totalPrice * rentalFee) / 10000;
        uint256 ownerAmount = totalPrice - fee;
        
        // Update rental
        rental.renter = msg.sender;
        rental.startTime = block.timestamp;
        rental.endTime = block.timestamp + (days * 1 days);
        rental.isActive = true;
        
        // Transfer funds to owner
        payable(rental.owner).transfer(ownerAmount);
        
        emit Rented(tokenId, msg.sender, days, totalPrice);
        
        // Refund excess
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
    }
    
    /**
     * @dev End rental (can be called by anyone after expiry)
     */
    function endRental(uint256 tokenId) external {
        Rental storage rental = rentals[tokenId];
        require(rental.isActive, "Not rented");
        require(block.timestamp >= rental.endTime, "Rental not expired");
        
        address renter = rental.renter;
        
        // Clear rental
        rental.renter = address(0);
        rental.startTime = 0;
        rental.endTime = 0;
        rental.isActive = false;
        
        emit RentalEnded(tokenId, renter);
    }
    
    /**
     * @dev Check if NFT is currently rented by address
     */
    function isRentedBy(uint256 tokenId, address user) external view returns (bool) {
        Rental memory rental = rentals[tokenId];
        return rental.isActive && 
               rental.renter == user && 
               block.timestamp < rental.endTime;
    }
    
    // ========== AUCTION FUNCTIONS ==========
    
    /**
     * @dev Create auction
     */
    function createAuction(
        uint256 tokenId,
        uint256 startPrice,
        uint256 durationDays
    ) external whenNotPaused {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not owner");
        require(startPrice > 0, "Start price must be > 0");
        require(durationDays > 0 && durationDays <= 30, "Invalid duration");
        require(!auctions[tokenId].isActive, "Auction exists");
        require(!listings[tokenId].isActive, "Listed for sale");
        require(!rentals[tokenId].isActive, "Currently rented");
        
        uint256 endTime = block.timestamp + (durationDays * 1 days);
        
        auctions[tokenId] = Auction({
            seller: msg.sender,
            tokenId: tokenId,
            startPrice: startPrice,
            highestBid: 0,
            highestBidder: address(0),
            endTime: endTime,
            isActive: true
        });
        
        emit AuctionCreated(tokenId, msg.sender, startPrice, endTime);
    }
    
    /**
     * @dev Place bid
     */
    function bid(uint256 tokenId) external payable nonReentrant whenNotPaused {
        Auction storage auction = auctions[tokenId];
        require(auction.isActive, "Auction not active");
        require(block.timestamp < auction.endTime, "Auction ended");
        require(msg.value >= auction.startPrice, "Bid too low");
        require(msg.value > auction.highestBid, "Bid not highest");
        
        // Refund previous bidder
        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }
        
        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;
        
        emit BidPlaced(tokenId, msg.sender, msg.value);
    }
    
    /**
     * @dev End auction and transfer NFT
     */
    function endAuction(uint256 tokenId) external nonReentrant {
        Auction storage auction = auctions[tokenId];
        require(auction.isActive, "Auction not active");
        require(block.timestamp >= auction.endTime, "Auction ongoing");
        
        auction.isActive = false;
        
        if (auction.highestBidder != address(0)) {
            // Calculate fee
            uint256 fee = (auction.highestBid * platformFee) / 10000;
            uint256 sellerAmount = auction.highestBid - fee;
            
            // Transfer NFT to winner
            nftContract.transferFrom(auction.seller, auction.highestBidder, tokenId);
            
            // Transfer funds to seller
            payable(auction.seller).transfer(sellerAmount);
            
            // Update volume
            totalVolume += auction.highestBid;
            
            emit AuctionEnded(tokenId, auction.highestBidder, auction.highestBid);
        } else {
            // No bids - auction failed
            emit AuctionEnded(tokenId, address(0), 0);
        }
    }
    
    // ========== ADMIN FUNCTIONS ==========
    
    /**
     * @dev Update platform fee
     */
    function setPlatformFee(uint256 newFee) external onlyOwner {
        require(newFee <= MAX_FEE, "Fee too high");
        platformFee = newFee;
        emit FeeUpdated(newFee);
    }
    
    /**
     * @dev Update rental fee
     */
    function setRentalFee(uint256 newFee) external onlyOwner {
        require(newFee <= MAX_FEE, "Fee too high");
        rentalFee = newFee;
    }
    
    /**
     * @dev Withdraw accumulated fees
     */
    function withdrawFees() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No fees to withdraw");
        payable(owner()).transfer(balance);
    }
    
    /**
     * @dev Pause marketplace
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Unpause marketplace
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    // ========== VIEW FUNCTIONS ==========
    
    /**
     * @dev Get all active listings (off-chain helper)
     */
    function getListingPrice(uint256 tokenId) external view returns (uint256) {
        require(listings[tokenId].isActive, "Not listed");
        return listings[tokenId].price;
    }
    
    /**
     * @dev Check if token is listed
     */
    function isListed(uint256 tokenId) external view returns (bool) {
        return listings[tokenId].isActive;
    }
    
    /**
     * @dev Get rental info
     */
    function getRentalInfo(uint256 tokenId) external view returns (
        address owner,
        address renter,
        uint256 pricePerDay,
        uint256 endTime,
        bool isActive
    ) {
        Rental memory rental = rentals[tokenId];
        return (
            rental.owner,
            rental.renter,
            rental.pricePerDay,
            rental.endTime,
            rental.isActive
        );
    }
    
    /**
     * @dev Get auction info
     */
    function getAuctionInfo(uint256 tokenId) external view returns (
        address seller,
        uint256 startPrice,
        uint256 highestBid,
        address highestBidder,
        uint256 endTime,
        bool isActive
    ) {
        Auction memory auction = auctions[tokenId];
        return (
            auction.seller,
            auction.startPrice,
            auction.highestBid,
            auction.highestBidder,
            auction.endTime,
            auction.isActive
        );
    }
}
