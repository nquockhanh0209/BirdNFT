// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./ISVC.sol";
import "./IBirdNFT.sol";


contract Marketplace{
    
    mapping(uint256 => uint256) private IdstoPrice;
    address public SVC;
    address public FlappyNFT;
    mapping(uint256 => bool) private listed;
    constructor(address _SVC, address _FlappyNFT) {
        SVC = _SVC;
        FlappyNFT = _FlappyNFT;
        
    }
    event Listing(uint256 tokenId, uint price, bool listed);
    event CancelListing(uint256 tokenId, bool listed);
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
        listed[tokenId] = false;
        emit cancelListing(tokenId, listed[tokenId]);
        return true;
    }

    function listingNFT(uint256 tokenId, uint256 price) external{
        require(listed[tokenId] == false, "token listed");
        IdstoPrice[tokenId] = price;
        listed[tokenId] = true;
        emit Listing(tokenId,price, true);
    }
    function viewPrice(uint256 tokenId) public view returns(uint) {
        require(listed[tokenId] == false, "token listed");
        return IdstoPrice[tokenId];
    }
    function cancelListing(uint256 tokenId) external {
        require(listed[tokenId] == true, "token not listed");
        listed[tokenId] = false;
        IdstoPrice[tokenId] = type(uint256).max;
        emit CancelListing(tokenId, false);
    }
    function checkListed(uint256 tokenId) public view returns(bool) {
        return listed[tokenId];
    }
   
}