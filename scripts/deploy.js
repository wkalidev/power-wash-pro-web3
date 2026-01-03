// scripts/deploy.js
const hre = require("hardhat");
const fs = require('fs');

async function main() {
  console.log("\n" + "=".repeat(60));
  console.log("🚀 POWER WASH PRO - Web3 Deployment");
  console.log("=".repeat(60) + "\n");
  
  const [deployer] = await hre.ethers.getSigners();
  console.log("📍 Deploying with account:", deployer.address);
  
  const balance = await deployer.getBalance();
  console.log("💰 Account balance:", hre.ethers.utils.formatEther(balance), "ETH\n");
  
  if (parseFloat(hre.ethers.utils.formatEther(balance)) < 0.01) {
    console.log("⚠️  WARNING: Low balance! You may need more ETH for deployment.\n");
  }
  
  // Deploy NFT Contract
  console.log("1️⃣  Deploying PowerWashNFT...");
  const PowerWashNFT = await hre.ethers.getContractFactory("PowerWashNFT");
  const nft = await PowerWashNFT.deploy();
  await nft.deployed();
  console.log("   ✅ NFT Contract:", nft.address);
  
  // Deploy Token Contract
  console.log("\n2️⃣  Deploying WashToken...");
  const WashToken = await hre.ethers.getContractFactory("WashToken");
  const token = await WashToken.deploy();
  await token.deployed();
  console.log("   ✅ Token Contract:", token.address);
  
  // Deploy Marketplace
  console.log("\n3️⃣  Deploying Marketplace...");
  const Marketplace = await hre.ethers.getContractFactory("PowerWashMarketplace");
  const marketplace = await Marketplace.deploy(nft.address);
  await marketplace.deployed();
  console.log("   ✅ Marketplace Contract:", marketplace.address);
  
  // Deploy Tournament
  console.log("\n4️⃣  Deploying Tournament...");
  const Tournament = await hre.ethers.getContractFactory("PowerWashTournament");
  const tournament = await Tournament.deploy(token.address);
  await tournament.deployed();
  console.log("   ✅ Tournament Contract:", tournament.address);
  
  // Configure Contracts
  console.log("\n⚙️  Configuring contracts...");
  
  console.log("   → Authorizing tournament for token rewards...");
  await token.addGameContract(tournament.address);
  console.log("   ✅ Tournament authorized");
  
  // Calculate deployment cost
  const finalBalance = await deployer.getBalance();
  const deploymentCost = balance.sub(finalBalance);
  console.log("\n💸 Total deployment cost:", hre.ethers.utils.formatEther(deploymentCost), "ETH");
  console.log("   (~$" + (parseFloat(hre.ethers.utils.formatEther(deploymentCost)) * 3000).toFixed(2) + " USD @ $3000/ETH)");
  
  // Save deployment info
  const deployment = {
    network: hre.network.name,
    deployer: deployer.address,
    deploymentCost: hre.ethers.utils.formatEther(deploymentCost),
    timestamp: new Date().toISOString(),
    contracts: {
      PowerWashNFT: {
        address: nft.address,
        txHash: nft.deployTransaction.hash
      },
      WashToken: {
        address: token.address,
        txHash: token.deployTransaction.hash
      },
      Marketplace: {
        address: marketplace.address,
        txHash: marketplace.deployTransaction.hash
      },
      Tournament: {
        address: tournament.address,
        txHash: tournament.deployTransaction.hash
      }
    }
  };
  
  // Save to file
  const filename = `deployment-${hre.network.name}-${Date.now()}.json`;
  fs.writeFileSync(filename, JSON.stringify(deployment, null, 2));
  console.log("\n💾 Deployment info saved to:", filename);
  
  // Save addresses for frontend
  const addresses = {
    NFT: nft.address,
    TOKEN: token.address,
    MARKETPLACE: marketplace.address,
    TOURNAMENT: tournament.address
  };
  
  fs.writeFileSync('deployed-addresses.json', JSON.stringify(addresses, null, 2));
  
  // Generate frontend config
  const frontendConfig = `
// Auto-generated contract addresses
const WEB3_CONFIG = {
  CHAIN_ID: ${hre.network.config.chainId},
  CHAIN_NAME: '${hre.network.name}',
  RPC_URL: '${hre.network.config.url}',
  EXPLORER: 'https://${hre.network.name === 'base' ? 'basescan.org' : 'sepolia.basescan.org'}',
  CONTRACTS: {
    NFT: '${nft.address}',
    TOKEN: '${token.address}',
    MARKETPLACE: '${marketplace.address}',
    TOURNAMENT: '${tournament.address}'
  }
};
`;
  
  fs.writeFileSync('frontend-config.js', frontendConfig);
  
  console.log("\n" + "=".repeat(60));
  console.log("📋 DEPLOYMENT SUMMARY");
  console.log("=".repeat(60));
  console.log("Network:             ", hre.network.name);
  console.log("Chain ID:            ", hre.network.config.chainId);
  console.log("Deployer:            ", deployer.address);
  console.log("-".repeat(60));
  console.log("NFT Contract:        ", nft.address);
  console.log("Token Contract:      ", token.address);
  console.log("Marketplace:         ", marketplace.address);
  console.log("Tournament:          ", tournament.address);
  console.log("=".repeat(60));
  
  console.log("\n📝 Next Steps:");
  console.log("   1. Wait for block confirmations (5-10 blocks)");
  console.log("   2. Verify contracts: npm run verify");
  console.log("   3. Update frontend with addresses from deployed-addresses.json");
  console.log("   4. Test NFT minting");
  console.log("   5. Add liquidity for WASH token");
  console.log("   6. Launch! 🚀\n");
  
  // Wait for confirmations
  console.log("⏳ Waiting for 5 block confirmations...");
  await nft.deployTransaction.wait(5);
  await token.deployTransaction.wait(5);
  await marketplace.deployTransaction.wait(5);
  await tournament.deployTransaction.wait(5);
  
  console.log("✅ Deployment complete!\n");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("\n❌ Deployment failed:");
    console.error(error);
    process.exit(1);
  });
