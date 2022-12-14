const { ethers, waffle} = require("hardhat");

const { expect } = require("chai");

describe("NFT", function () {
  
      
    
   
 
  describe("test", () =>{
    let owner
    let client1 
    let client2
    let birdNFT
    let marketplace
    before(async ()=>{
    [owner, client1, client2] = await ethers.getSigners();
    
    const ERC20Basic = await ethers.getContractFactory("ERC20Basic");
    token = await ERC20Basic.deploy(10000);
    await token.deployed();

    const BirdNFT = await ethers.getContractFactory("BirdNFT");
    birdNFT = await BirdNFT.deploy("", owner.address);
    await birdNFT.deployed();

    const Marketplace = await ethers.getContractFactory("Marketplace");
    marketplace = await Marketplace.deploy(token.address, birdNFT.address);
    await marketplace.deployed();
   })
   it("test listing", async function () {
    //client1 have 10 svc 
    await token.transferFrom(owner.address,client1.address,11);
    //mint nft for owner
    await birdNFT.createSeveral1155NFT(owner.address, "", 1, [1]);
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
    console.log(await token.balanceOf(owner.address));
    console.log(await token.balanceOf(client1.address));
    
  });
  it("test listing", async function () {
    const msgParams = JSON.stringify({
      types: {
        EIP712Domain: [
          { name: "name", type: "string" },
          { name: "version", type: "string" },
          { name: "chainId", type: "uint256" },
          { name: "verifyingContract", type: "address" },
        ],
        Permit: [
            { name: "owner", type: "address" },
            { name: "spender", type: "address" },
            { name: "tokenId", type: "uint256" },
            { name: "deadline", type: "uint256" },
            { name: "nonce", type: "uint256" },
          ]
      },
      //make sure to replace verifyingContract with address of deployed contract
      primaryType: "permit",
      domain: {
        name: "permission",
          version: "1",
          chainId: 31337,
          verifyingContract: birdNFT.address,
      },
      message: {
        owner: owner.address,
          spender: birdNFT.address,
          tokenId: 0,
          deadline: 100000000000,
          nonce: 0
      },
  })

  console.log(msgParams);
  ethereum.request({
    method: "eth_signtypeddata_v4",
    params: [owner.address, msgParams]
  });
  });
  })
})
    