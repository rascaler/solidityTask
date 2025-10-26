// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import "./NftAuction.sol";

contract NftAuctionV2 is NftAuction {
    function newFunction() public pure returns (string memory) {
        return "This is a new function in NftAuctionV2";
    }
}