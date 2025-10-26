// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;
 
contract Sort {

    function sort(uint[] memory a, uint[] memory b) public pure returns(uint[] memory){
        uint[] memory result = new uint[](a.length + b.length);
        uint i = 0;
        uint j = 0;
        uint k = 0;
        while (i < a.length || j < b.length) {
            if (i == a.length) {
                result[k] = b[j];
                k++;
                j++;
                continue;
            }
            if (j == b.length) {
                result[k] = a[i];
                k++;
                i++;
                continue;
            }
            if (a[i] < b[j]) {
                result[k] = a[i];
                k++;
                i++;
            } else {
                result[k] = b[j];
                k++;
                j++;
            }
        }
        return result;
    }
}