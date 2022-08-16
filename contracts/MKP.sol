// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Import this file to use console.log
import "hardhat/console.sol";
import "./ISVC.sol";
import "./IBirdNFT.sol";


contract Marketplace{
    mapping(uint256 => uint) private IdstoPrice;
    address public SVC;
    address public FlappyNFT;
    mapping(uint256 => bool) private listed;
    constructor(address _SVC, address _FlappyNFT) {
        SVC = _SVC;
        FlappyNFT = _FlappyNFT;
        
    }
    event Listing(uint256 tokenId, uint price, bool listed);
    event CancelListing(uint256 tokenId, bool listed);
    // function buyNFT(address buyer, address seller, uint256 tokenId) external returns(bool){
    //     require(listed[tokenId],"NFT not listed");
    //     uint256[] memory id = new uint256[](1);
    //     id[0] = tokenId;
    //     uint256[] memory amount = new uint256[](1);
    //     amount[0] = 1;

    //     require(ISavvyCoin(SVC).transferFrom(buyer, seller, IdstoPrice[tokenId]),"insufficient balances for buy");

    //     //require(INFT_1155(FlappyNFT).transferBatch1155NFT(seller, buyer,id,amount),"transfer NFT fail");
        
    //     require(INFT_1155(FlappyNFT).transferBatch1155NFT(seller, buyer,id,amount),"transfer NFT fail");
    //     return true;
    // }

    function buyNFT(
        address buyer, 
        address seller, 
        uint256 tokenId,
        uint256 deadline, 
        uint256 nonce, 
        uint8 v, 
        bytes32 r, 
        bytes32 s
        ) external returns(bool){
        require(listed[tokenId],"NFT not listed");
        uint256[] memory id = new uint256[](1);
        id[0] = tokenId;
        uint256[] memory amount = new uint256[](1);
        amount[0] = 1;

        require(ISavvyCoin(SVC).transferFrom(buyer, seller, IdstoPrice[tokenId]),"insufficient balances for buy");
        
        require(IBirdNFT(FlappyNFT).transferWithPermission(seller, buyer, tokenId, deadline, nonce, v, r, s),"transfer NFT fail");
        //require(IBirdNFT(FlappyNFT).transferBatch1155NFT(seller, buyer, id, amount),"transfer NFT fail");
        return true;
    }

    function listingNFT(uint256 tokenId, uint price) external{
        IBirdNFT(FlappyNFT).approveAll1155NFT(msg.sender, address(this), true);
        IdstoPrice[tokenId] = price;
        updateListing(tokenId, true);
        emit Listing(tokenId,price, true);
    }
    function viewPrice(uint256 tokenIds) public view returns(uint) {
        return IdstoPrice[tokenIds];
    }
    function cancelListing(uint256 tokenId) external {
        IBirdNFT(FlappyNFT).approveAll1155NFT(msg.sender, address(this), false);
        updateListing(tokenId, false);
        emit CancelListing(tokenId,false);
    }
    function checkListed(uint256 tokenId) public view returns(bool) {
        return listed[tokenId];
    }
    function updateListing(uint256 tokenId, bool isListed) internal{
        listed[tokenId] = isListed;
    }
}