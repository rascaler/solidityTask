// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NftAuction is UUPSUpgradeable, OwnableUpgradeable {
    struct Auction {
        // 卖家
        address seller;
        // 拍卖持续时间
        uint256 duration;
        // 起拍价
        uint256 startingBid;
        // 拍卖开始时间
        uint256 startTime;
        // 拍卖结束时间
        uint256 endTime;
        // 拍卖是否结束
        bool ended;
        // 最高出价者
        address highestBidder;
        // 最高出价
        uint256 highestBid;
        // nft合约地址
        address nftAddress;
        // nft tokenId
        uint256 tokenId;
        // token类型
        address tokenAddress;
    }

    // 拍卖列表
    mapping(uint256 => Auction) public auctions;

    // 下一个拍卖ID
    uint256 public nextAuctionId;

    // 管理员地址，用于创建拍卖
    address public admin;

    // 预言机喂价地址
    mapping(address => AggregatorV3Interface) public priceFeeds;

    // 设置代币价格喂价地址
    function setPriceFeed(address _tokenAddress, address _priceFeed) public onlyOwner {
        priceFeeds[_tokenAddress] = AggregatorV3Interface(_priceFeed);
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        admin = msg.sender;
        nextAuctionId = 1;
    }

    // 创建拍卖 
    function createAuction(
        uint256 _tokenId,
        address _nftAddress,
        uint256 _startingBid,
        uint256 _duration
    ) public onlyOwner {
        require(_duration > 60, "Invalid duration");
        require(_startingBid > 0, "Invalid starting bid");
        // 将nft转移到合约地址
        IERC721(_nftAddress).transferFrom(msg.sender, address(this), _tokenId);
        auctions[nextAuctionId] = Auction({
            seller: msg.sender,
            tokenId: _tokenId,
            nftAddress: _nftAddress,
            duration: _duration,
            startingBid: _startingBid,
            highestBid: 0,
            highestBidder: address(0),
            endTime: block.timestamp + _duration,
            startTime: block.timestamp,
            ended: false,
            tokenAddress: address(0)
        });
        nextAuctionId++;
    }

    // 价格转换为USD
    function convert(uint256 _amount, address _tokenAddress) public view returns (uint256) {
        AggregatorV3Interface priceFeed = priceFeeds[_tokenAddress];
        require(address(priceFeed) != address(0), "No price feed for this token");
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return (_amount * uint256(price));
    }


    // 出价
    // 允许使用ETH或ERC20代币出价
    function bid(uint256 _auctionId, uint256 _amount, address _tokenAddress) public payable {
        Auction storage auction = auctions[_auctionId];
        require(block.timestamp < auction.endTime, "Auction ended");
        // 转换价格单位
        
        uint256 usd;
        if (_tokenAddress != address(0)) {
            usd = convert(_amount, _tokenAddress);
        } else {
            usd = convert(msg.value, address(0));
        }
        // 检查出价是否高于起拍价和当前最高价
        require(usd > auction.startingBid, "Invalid bid amount");
        require(usd > auction.highestBid, "Invalid bid amount");
        

        // 退还之前的最高出价者
        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }else {
            // 如果是ERC20代币出价，转移代币
            IERC20(_tokenAddress).transferFrom(msg.sender, address(this), auction.highestBid);
        }

        // 更新最高出价和最高出价者
        auction.highestBid = usd;
        auction.highestBidder = msg.sender;
    }

    // 结束拍卖
    function endAuction(uint256 _tokenId) public {
        Auction storage auction = auctions[_tokenId];
        require(block.timestamp >= auction.endTime, "Auction not ended");
        require(!auction.ended, "Auction already ended");  
        auction.ended = true;
        // 将NFT转移给最高出价者
        if (auction.highestBidder != address(0)) {
            IERC721(auction.nftAddress).transferFrom(
                address(this),
                auction.highestBidder,
                auction.tokenId
            );
            // 将最高出价转移给卖家
            payable(auction.seller).transfer(auction.highestBid);
        } else {
            // 如果没有人出价，将NFT退还给卖家
            IERC721(auction.nftAddress).transferFrom(
                address(this),
                auction.seller,
                auction.tokenId
            );
        }
    }

    function _authorizeUpgrade(address newImplementation) 
        internal override onlyOwner 
    { 
    }
}