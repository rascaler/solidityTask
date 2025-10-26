// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


// 任务目标
// 使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
// 记录每个捐赠者的地址和捐赠金额。
// 允许合约所有者提取所有捐赠的资金。

// 任务步骤
// 编写合约
// 创建一个名为 BeggingContract 的合约。
// 合约应包含以下功能：
// 一个 mapping 来记录每个捐赠者的捐赠金额。
// 一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
// 一个 withdraw 函数，允许合约所有者提取所有资金。
// 一个 getDonation 函数，允许查询某个地址的捐赠金额。
// 使用 payable 修饰符和 address.transfer 实现支付和提款。
// 部署合约
// 在 Remix IDE 中编译合约。
// 部署合约到 Goerli 或 Sepolia 测试网。
// 测试合约
// 使用 MetaMask 向合约发送以太币，测试 donate 功能。
// 调用 withdraw 函数，测试合约所有者是否可以提取资金。
// 调用 getDonation 函数，查询某个地址的捐赠金额。

// 任务要求
// 合约代码：
// 使用 mapping 记录捐赠者的地址和金额。
// 使用 payable 修饰符实现 donate 和 withdraw 函数。
// 使用 onlyOwner 修饰符限制 withdraw 函数只能由合约所有者调用。
// 测试网部署：
// 合约必须部署到 Goerli 或 Sepolia 测试网。
// 功能测试：
// 确保 donate、withdraw 和 getDonation 函数正常工作。

// 提交内容
// 合约代码：提交 Solidity 合约文件（如 BeggingContract.sol）。
// 合约地址：提交部署到测试网的合约地址。
// 测试截图：提交在 Remix 或 Etherscan 上测试合约的截图。

// 额外挑战（可选）
// 捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
// 捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
// 时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。


// 合约地址
// 
contract BeggingContract is Ownable{
    constructor() Ownable(msg.sender){}

    // 捐赠者捐赠金额记录
    mapping(address => uint256) private donations;

    event donation(address indexed donor, uint256 amount);

    modifier timeLimit() {
        // 仅允许在特定时间段内捐赠，例如每天的 9 点到 17 点（UTC 时间）
        uint256 hour = (block.timestamp / 60 / 60) % 24;
        require(hour >= 1 && hour <= 23, "Donations are only accepted between 1 AM and 11 PM UTC");
        _;
    }

    function donate() public payable timeLimit{
        require(msg.value > 0, "Donation must be greater than 0");
        donations[msg.sender] += msg.value;
        emit donation(msg.sender, msg.value);
    }


    // 合约所有者提取所有资金。
    function withdraw() public onlyOwner {
        // 仅合约所有者可调用
        payable(owner()).transfer(address(this).balance);
    } 

    // 查询某个地址的捐赠金额。
    function getDonation(address donor) public view returns (uint256) {
        return donations[donor];
    }

    function total() public view returns (uint256) {
        return address(this).balance;
    }   

}