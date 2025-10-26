// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract ReverseString {
    function reverse(string memory input) public pure returns (string memory) {
        bytes memory bytesInput = bytes(input);
        bytes memory reversedBytes = new bytes(bytesInput.length);
        for (uint i = 0; i < bytesInput.length; i++) {
            reversedBytes[i] = bytesInput[bytesInput.length - 1 - i];
        }
        return string(reversedBytes);
    }
}