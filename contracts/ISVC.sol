// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
interface ISavvyCoin{
    function transferFrom(address owner, address buyer, uint256 numTokens) external returns (bool);
}