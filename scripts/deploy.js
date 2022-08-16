// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
    let [owner, client1, client2] = await ethers.getSigners();
    
    const ERC20Basic = await ethers.getContractFactory("ERC20Basic");
    let token = await ERC20Basic.deploy(10000);
    await token.deployed();

    const NFT_1155 = await ethers.getContractFactory("NFT_1155");
    let nft1155 = await NFT_1155.deploy("", owner.address);
    await nft1155.deployed();

    const Marketplace = await ethers.getContractFactory("Marketplace");
    let marketplace = await Marketplace.deploy(token.address, nft1155.address);
    await marketplace.deployed();
    await token.transferFrom(owner.address,client1.address,11);
    //mint nft for owner
    await nft1155.createSeveral1155NFT(owner.address, "", 1, [1],[true]);
    console.log(await nft1155.NFTbalance([owner.address, client1.address],[0,0]));
    //transfer
    await marketplace.listingNFT(0, 10);
    let signature = await owner._signTypedData(
      {
        name: "permission",
        version: "1",
        chainId: 31337,
        verifyingContract: nft1155.address,
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
        spender: nft1155.address,
        tokenId: 0,
        deadline: 100000000000,
        nonce: 0,
      }
    );
    signature = signature.substring(2);
    const r = "0x" + signature.substring(0, 64);
    const s = "0x" + signature.substring(64, 128);
    const v = parseInt(signature.substring(128, 130), 16);
    console.log(owner.address," next ", client1.address);
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

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
