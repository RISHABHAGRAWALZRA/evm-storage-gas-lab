// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MemoryVsCalldata} from "../contracts/MemoryVsCalldata.sol";

contract MemoryVsCalldataTest is Test {
    MemoryVsCalldata m;

    function setUp() public {
        m = new MemoryVsCalldata();
    }

    function test_Gas_sumMemory() public {
        uint256[] memory arr = new uint[](100);
        for (uint256 i = 0; i < 100; i++) {
            arr[i] = i + 1;
        }

        uint256 gasStart = gasleft();
        m.sumMemory(arr);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("sumMemory gas", gasUsed);
    }

    function test_Gas_sumCalldata() public {
        uint256[] memory arr = new uint[](100);
        for (uint256 i = 0; i < 100; i++) {
            arr[i] = i + 1;
        }

        uint256 gasStart = gasleft();
        m.sumCalldata(arr);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("sumCalldata gas", gasUsed);
    }
}
