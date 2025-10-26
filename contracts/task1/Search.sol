// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;
 
contract Search {

    function search(int[] memory a, int target) public pure returns(int){
       uint left = 0;
       uint right = a.length - 1;
       uint mid = (left + right)/2;
       int result = -1;
       // 0,1,2
       // 0,1,2,3

       while(left <= right) {
           if (mid == left || mid == right) {
            if (a[mid] == target) {
                result = int(mid);
            }
            break;
           }
           if(a[mid] == target) {
               result = int(mid);
               break;
           } else if(a[mid] < target) {
               left = mid + 1;
               mid = (left + right)/2;
           } else {
               right = mid - 1;
               mid = (left + right)/2;
           }
       }
       return result;
    }
}