// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./NftAuction.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NftAuctionFactory is Ownable {
    NftAuction[] public auctions;

    mapping(uint256 => NftAuction) public auctionMap;

    event AuctionCreated(address auctionAddress);
    
    constructor() Ownable(msg.sender) {}

    // 创建一个新的NftAuction合约实例
    function createAuction(uint256 _tokenId, address _nftAddress, uint256 _startingBid, uint256 _duration) public onlyOwner {   
        NftAuction auction = new NftAuction();
        auction.initialize();
        auction.createAuction(_tokenId, _nftAddress, _startingBid, _duration);
        emit AuctionCreated(address(auction));
        auctions.push(auction);
    }

    function getAuctions() public view returns (NftAuction[] memory) {
        return auctions;
    }

    function getAuction(uint256 _tokenId) public view returns (NftAuction) {
        return auctionMap[_tokenId];
    }
}