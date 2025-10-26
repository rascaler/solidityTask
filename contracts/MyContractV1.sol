// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MyContractV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 public value;
    string public version;

    function initialize() initializer public {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        value = 0;
        version = "v1";
    }

    function setValue(uint256 newValue) public {
        value = newValue;
    }

    // 必须重写此函数以控制谁可以升级合约
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}