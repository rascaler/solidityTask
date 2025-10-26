// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Voting {
    mapping(address => uint32) public tickets;
    mapping(address => bool) public exists;
    address[] public keys;

    // 投票
    function vote(address candidate) public {
        // 判断key是否存在
        if (!exists[candidate]) {
            exists[candidate] = true;
            tickets[candidate] = 1;
            keys.push(candidate);
        } else {
            tickets[candidate] += 1;
        }
    }
    
    // 返回候选人得票数
    function getVotes(address candidate) public view returns(uint32) {
        return tickets[candidate];
    }

    // 重置所有候选人得票数
    function resetVotes() public {
        for (uint i = 0; i < keys.length;i++) {
            tickets[keys[i]] = 0;
            exists[keys[i]] = false;
            keys.pop();
        }
    }
}
