//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./IBirdNFT.sol";



contract BirdNFT is ERC1155, ERC1155URIStorage, IBirdNFT{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(address => uint256) private nonces;
    mapping(address => mapping(address => uint)) approval;
    mapping(uint256 => mapping(address => uint256)) private owner_balances;
    mapping(uint256 => uint256) public tokenSupply;
    mapping(uint256 => bool) private uniqueNFT;
    event TransferWithPermission(address from, address to, uint256 tokenId);
    address public owner;
    bytes32 public immutable DOMAIN_SEPARATOR;
    constructor(string memory NFT_URI, address _owner) ERC1155(NFT_URI) {
        owner = _owner;
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes("permission")),
                keccak256(bytes("1")),
                31337,
                address(this)
            )
        );
    }
    modifier OnlyOwner{
        require(msg.sender == owner);
        _;
    }
    function createSeveral1155NFT(
        address creator,
        string[] memory tokenURI,
        uint256 idsAmount,
        uint256[] memory amount
    ) external OnlyOwner {
        //the number of ids must equal to amount length
        require(idsAmount == amount.length, "1234");

        uint256[] memory newIdsArray = new uint256[](idsAmount);

        for (uint i = 0; i < idsAmount; i++) {
            newIdsArray[i] = _tokenIds.current();
            _tokenIds.increment();
        }

        _mintBatch(creator, newIdsArray, amount, "");
        for (uint i = 0; i < idsAmount; i++) {
            _setURI(newIdsArray[i], tokenURI[i]);
          
            owner_balances[newIdsArray[i]][creator] = amount[i];
        }
      
    }
    
    function transferBatch1155NFT(
        address from,
        address to,
        uint256[] memory Ids,
        uint256[] memory amount
    ) public virtual override returns(bool){
        _safeBatchTransferFrom(from, to, Ids, amount, "");
        emit Transfer(from, to, Ids, amount);
        return true;
    }

    // //enhance transfer from 0ne to more
    // function transferBatchfromOnetoMore(
    //     address from, 
    //     address[] memory to, 
    //     uint256[][] memory Ids, 
    //     uint256[][] memory amount
    // ) public {
    //     require(to.length == Ids.length,"address and Ids not match");
        
    //     for(uint i = 0; i < to.length; i++) {
    //         _safeBatchTransferFrom(from, to[i], Ids[i], amount[i], "");
    //     }
    // }
    function NFTbalance(address[] memory account, uint256[] memory Ids)
        public
        view
        override
        returns (uint256[] memory)
    {
        return balanceOfBatch(account, Ids);
    }
     function permit(
        address owner,
        address spender,
        uint256 tokenId,
        uint256 deadline,
        uint256 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public returns (bool) {
        bytes32 hashStruct = keccak256(
            abi.encode(
                keccak256(
                    "Permit(address owner,address spender,uint256 tokenId,uint256 deadline,uint256 nonce)"
                ),
                owner,
                spender,
                tokenId,
                deadline,
                nonce
            )
        );

        bytes32 EIP721hash = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashStruct)
        );
        
        require(owner != address(0), "invalid address");
        require(owner == ecrecover(EIP721hash, v, r, s), "invalid owner");
        require(deadline == 0 || deadline >= block.timestamp, "permit expired");
        require(nonce == nonces[owner]++, "Invalid nonce");
        
        approval[owner][spender] = tokenId;
        return true;
    }
    
    function transferWithPermission(
        address from,
        address to,
        uint256 tokenId,
        uint256 deadline,
        uint256 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual override returns(bool){
         require(
            permit(from, address(this), tokenId, deadline, nonce, v, r, s),
            "not permitted"
        );
        
        uint256[] memory id = new uint256[](1);
        id[0] = tokenId;
        uint256[] memory amount = new uint256[](1);
        amount[0] = 1;
        _safeBatchTransferFrom(from, to, id, amount, "");
        emit TransferWithPermission(from, to, tokenId);
        return true;
    }
    function approveAll1155NFT(
        address owner,
        address operator,
        bool approved
    ) public virtual override {
        _setApprovalForAll(owner, operator, approved);
    }
}
