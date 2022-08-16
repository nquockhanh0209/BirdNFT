// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
interface IBirdNFT{
    function transferBatch1155NFT(
        address from,
        address to,
        uint256[] memory Ids,
        uint256[] memory amount
    ) external returns(bool);
    function NFTbalance(address[] memory account, uint256[] memory Ids)
        external
        returns (uint256[] memory);
    function approveAll1155NFT(
        address owner,
        address operator,
        bool approved
    ) external;
    function permit(
        address owner,
        address spender,
        uint256 tokenId,
        uint256 deadline,
        uint256 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool);
   function transferWithPermission(
        address from,
        address to,
        uint256 tokenId,
        uint256 deadline,
        uint256 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns(bool);
    event Transfer(
        address from,
        address to,
        uint256[] Ids,
        uint256[] amount);
}