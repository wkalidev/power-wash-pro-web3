// scripts/verify.js
const hre = require("hardhat");
const addresses = require('../deployed-addresses.json');

async function main() {
  console.log("\n🔍 Verifying contracts on Basescan...\n");
  
  try {
    // Verify NFT Contract
    console.log("1️⃣  Verifying PowerWashNFT...");
    await hre.run("verify:verify", {
      address: addresses.NFT,
      constructorArguments: []
    });
    console.log("   ✅ NFT verified!\n");
    
    // Verify Token Contract
    console.log("2️⃣  Verifying WashToken...");
    await hre.run("verify:verify", {
      address: addresses.TOKEN,
      constructorArguments: []
    });
    console.log("   ✅ Token verified!\n");
    
    // Verify Marketplace
    console.log("3️⃣  Verifying Marketplace...");
    await hre.run("verify:verify", {
      address: addresses.MARKETPLACE,
      constructorArguments: [addresses.NFT]
    });
    console.log("   ✅ Marketplace verified!\n");
    
    // Verify Tournament
    console.log("4️⃣  Verifying Tournament...");
    await hre.run("verify:verify", {
      address: addresses.TOURNAMENT,
      constructorArguments: [addresses.TOKEN]
    });
    console.log("   ✅ Tournament verified!\n");
    
    console.log("=".repeat(60));
    console.log("✅ All contracts verified on Basescan!");
    console.log("=".repeat(60));
    console.log("\n📖 View contracts:");
    console.log("   NFT:         https://basescan.org/address/" + addresses.NFT);
    console.log("   Token:       https://basescan.org/address/" + addresses.TOKEN);
    console.log("   Marketplace: https://basescan.org/address/" + addresses.MARKETPLACE);
    console.log("   Tournament:  https://basescan.org/address/" + addresses.TOURNAMENT);
    console.log("");
    
  } catch (error) {
    console.error("\n❌ Verification failed:");
    console.error(error.message);
    console.log("\n💡 Tip: Make sure you have BASESCAN_API_KEY in your .env file");
    console.log("   Get one at: https://basescan.org/myapikey\n");
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
