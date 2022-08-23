// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  let birdNFT
  let marketplace


  const BirdNFT = await ethers.getContractFactory("BirdNFT");
  birdNFT = await BirdNFT.deploy("", "0x0B51B7d1A31516aEF06aaf545F2fcC3827141aE4");
  await birdNFT.deployed();
  console.log("Deploy BirdNFT at:", birdNFT.address);
  const Marketplace = await ethers.getContractFactory("Marketplace");
  marketplace = await Marketplace.deploy("0xFF3b8ae2FDfbA5daAdcee60FC3E346CAdBcdfb3c", birdNFT.address);
  await marketplace.deployed();
  console.log("Deploy marketplace at:", marketplace.address);

  
}

    
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
