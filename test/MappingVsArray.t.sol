// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MappingVsArray} from "../contracts/MappingVsArray.sol";

contract MappingVsArrayTest is Test {
    MappingVsArray m;

    function setUp() public {
        m = new MappingVsArray();
    }

    function test_GasForWriteArray() public {
        uint256 n = 100;

        uint256 gasStart = gasleft();
        m.populateArray(n);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used for write Array: ", gasUsed);
    }

    function test_GasForWriteMapping() public {
        uint256 n = 100;

        uint256 gasStart = gasleft();
        m.populateMapping(n);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used for write Mapping: ", gasUsed);
    }

    function test_GasForReadFromArray() public {
        uint256 n = 100;
        m.populateArray(n);

        uint256 gasStart = gasleft();
        m.readFromArray(50);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used for readFromArray: ", gasUsed);
    }

    function test_GasForReadFromMapping() public {
        uint256 n = 100;
        m.populateMapping(n);

        uint256 gasStart = gasleft();
        m.readFromMapping(50);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used for readFromMapping: ", gasUsed);
    }

    function test_Array_Storage_Slot() public {
        m.populateArray(1);

        bytes32 base = keccak256(abi.encode(uint256(0)));
        bytes32 slot0 = vm.load(address(m), base);

        assertEq(uint256(slot0), 0);
    }

    function test_Mapping_Storage_Slot() public {
        m.populateMapping(2);

        bytes32 slot = keccak256(abi.encode(uint256(1), uint256(1)));
        bytes32 value = vm.load(address(m), slot);

        assertEq(uint256(value), 1);
    }
}
