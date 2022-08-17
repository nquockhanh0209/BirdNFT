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