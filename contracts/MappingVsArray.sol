// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MappingVsArray {
    uint256[] public arr;
    mapping(uint256 => uint256) public map;

    function populateArray(uint256 n) public {
        for (uint256 i = 0; i < n; i++) {
            arr.push(i);
        }
    }

    function populateMapping(uint256 n) public {
        for (uint256 i = 0; i < n; i++) {
            map[i] = i;
        }
    }

    function readFromArray(uint256 index) public view returns (uint256) {
        return arr[index];
    }

    function readFromMapping(uint256 key) public view returns (uint256) {
        return map[key];
    }

    function getArrayLength() public view returns (uint256) {
        return arr.length;
    }

    // Not possible
    // function getMapLength() public view returns (uint256) {
    //     return map.length;
    // }
}
