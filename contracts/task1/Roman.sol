// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Roman{

    mapping(bytes1 => uint) private ROMAN_MAP;

    mapping(bytes2 => uint) private ROMAN_COMPLEX_MAP;

    constructor() {
        ROMAN_MAP["I"] = 1;
        ROMAN_MAP["V"] = 5;
        ROMAN_MAP["X"] = 10;
        ROMAN_MAP["L"] = 50;
        ROMAN_MAP["C"] = 100;
        ROMAN_MAP["D"] = 500;
        ROMAN_MAP["M"] = 1000;
        ROMAN_COMPLEX_MAP["IV"] = 4;
        ROMAN_COMPLEX_MAP["IX"] = 9;
        ROMAN_COMPLEX_MAP["XL"] = 40;
        ROMAN_COMPLEX_MAP["XC"] = 90;
        ROMAN_COMPLEX_MAP["CD"] = 400;
        ROMAN_COMPLEX_MAP["CM"] = 900;
    }
    

    // 罗马转数字
    function romanToInt(string memory romanNumber) public view returns (uint) {
        bytes memory romanBytes = bytes(romanNumber);
        uint result = 0;
        for(uint i =0;i < romanBytes.length;i++) {
            if(i+1 < romanBytes.length) {
                bytes2 tmp = bytes2((uint16(uint8(romanBytes[i]))  << 8) | uint16(uint8(romanBytes[i+1])));
                if(ROMAN_COMPLEX_MAP[tmp] > 0) {
                    result += ROMAN_COMPLEX_MAP[tmp];
                    i+=2;
                } else {
                    result += ROMAN_MAP[romanBytes[i]];
                }
            } else {
                result += ROMAN_MAP[romanBytes[i]];
            }
        }
        return result;
    }


    // 数字转罗马
    function intToRoman(uint number) public pure returns (string memory) {
        uint temp = number;
        string memory result = "";
        while (temp > 0) {
            if (temp >= 1000) {
                temp -= 1000;
                result = string(abi.encodePacked(result, "M"));
            } else if (temp >= 900) {
                temp -= 900;
                result = string(abi.encodePacked(result, "CM"));
            } else if (temp >= 500) {
                temp -= 500;
                result = string(abi.encodePacked(result, "D"));
            } else if (temp >= 400) {
                temp -= 400;
                result = string(abi.encodePacked(result, "CD"));
            } else if (temp >= 100) {
                temp -= 100;
                result = string(abi.encodePacked(result, "C"));
            } else if (temp >= 90) {
                temp -= 90;
                result = string(abi.encodePacked(result, "XC"));
            } else if (temp >= 50) {
                temp -= 50;
                result = string(abi.encodePacked(result, "L"));
            } else if (temp >= 40) {
                temp -= 40;
                result = string(abi.encodePacked(result, "XL"));
            } else if (temp >= 10) {
                temp -= 10;
                result = string(abi.encodePacked(result, "X"));
            } else if (temp >= 9) {
                temp -= 9;
                result = string(abi.encodePacked(result, "IX"));
            } else if (temp >= 5) {
                temp -= 5;
                result = string(abi.encodePacked(result, "V"));
            } else if (temp >= 4) {
                temp -= 4;
                result = string(abi.encodePacked(result, "IV"));
            } else {
                temp -= 1;
                result = string(abi.encodePacked(result, "I"));
            }
        }
        return result;
    }
}
