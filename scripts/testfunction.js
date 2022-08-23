// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  let owner
  let client1 
  let client2
  let birdNFT
  let marketplace
  [owner, client1, client2] = await ethers.getSigners();
    
  const SVCToken = await ethers.getContractFactory("SVCToken");
  svctoken = await SVCToken.deploy();
  await svctoken.deployed();

  const BirdNFT = await ethers.getContractFactory("BirdNFT");
  birdNFT = await BirdNFT.deploy("", owner.address);
  await birdNFT.deployed();

  const Marketplace = await ethers.getContractFactory("Marketplace");
  marketplace = await Marketplace.deploy(svctoken.address, birdNFT.address);
  await marketplace.deployed();
  //client1 have 10 svc 
  await svctoken.transferFrom(owner.address,client1.address,11);
  //mint nft for owner
  await birdNFT.createSeveral1155NFT(owner.address, "", 10, [1,1,1,1,1,1,1,1,1,1]);
  console.log(await birdNFT.NFTbalance([owner.address, client1.address],[0,0]));
  //transfer
  await marketplace.listingNFT(0, 10);
  let signature = await owner._signTypedData(
    {
      name: "permission",
      version: "1",
      chainId: 31337,
      verifyingContract: birdNFT.address,
    },
    {
      Permit: [
        { name: "owner", type: "address" },
        { name: "spender", type: "address" },
        { name: "tokenId", type: "uint256" },
        { name: "deadline", type: "uint256" },
        { name: "nonce", type: "uint256" },
      ],
    },
    {
      owner: owner.address,
      spender: birdNFT.address,
      tokenId: 0,
      deadline: 100000000000,
      nonce: 0,
    }
  );
  signature = signature.substring(2);
  const r = "0x" + signature.substring(0, 64);
  const s = "0x" + signature.substring(64, 128);
  const v = parseInt(signature.substring(128, 130), 16);
  await marketplace.buyNFT(
    client1.address,
    owner.address,
    0,
    100000000000,
    0,
    v,
    r,
    s
    )
  console.log(await birdNFT.NFTbalance([owner.address, client1.address],[0,0]));   
}

    
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
