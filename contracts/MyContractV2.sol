// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./MyContractV1.sol"; // 继承状态，也可以直接继承基类

contract MyContractV2 is MyContractV1 {
    // 新增一个函数
    function setValuePlusOne(uint256 newValue) public {
        value = newValue + 1;
    }

    // 可以更新版本号
    function upgradeToV2() public {
        version = "v2";
    }
}