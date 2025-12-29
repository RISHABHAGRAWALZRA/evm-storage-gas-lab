// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {StoragePacking} from "../contracts/StoragePacking.sol";

contract StoragePackingTest is Test {
    StoragePacking storagePacking;

    function setUp() public {
        storagePacking = new StoragePacking();
    }

    function test_GasForWriteUnpacked() public {
        uint256 a = 1;
        uint8 b = 2;
        uint256 c = 3;

        uint256 gasStart = gasleft();
        storagePacking.writeUnpacked(a, b, c);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used for writeUnpacked: ", gasUsed);
    }

    function test_GasForWritePacked() public {
        uint128 a = 1;
        uint64 b = 2;
        uint64 c = 3;

        uint256 gasStart = gasleft();
        storagePacking.writePacked(a, b, c);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used for writePacked: ", gasUsed);
    }

    function test_GasForReadUnpacked() public {
        uint256 a = 1;
        uint8 b = 2;
        uint256 c = 3;

        storagePacking.writeUnpacked(a, b, c);

        uint256 gasStart = gasleft();
        storagePacking.readUnpacked(0);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used for readUnpacked: ", gasUsed);
    }

    function test_GasForReadPacked() public {
        uint128 a = 1;
        uint64 b = 2;
        uint64 c = 3;

        storagePacking.writePacked(a, b, c);

        uint256 gasStart = gasleft();
        storagePacking.readPacked(0);
        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used for readPacked: ", gasUsed);
    }

    function test_Unpacked_StorageSlots() public {
        storagePacking.writeUnpacked(11, 22, 33);

        // Base slot of unpackedArray = 0
        bytes32 base = keccak256(abi.encode(uint256(0)));

        // slot for element 0
        bytes32 slotA = vm.load(address(storagePacking), base);
        bytes32 slotB = vm.load(
            address(storagePacking),
            bytes32(uint256(base) + 1)
        );
        bytes32 slotC = vm.load(
            address(storagePacking),
            bytes32(uint256(base) + 2)
        );

        assertEq(uint256(slotA), 11);
        assertEq(uint256(slotB), 22);
        assertEq(uint256(slotC), 33);
    }

    function test_Packed_StorageSlots() public {
        storagePacking.writePacked(11, 22, 33);

        // Base slot of packedArray = 1
        bytes32 base = keccak256(abi.encode(uint256(1)));

        // slot for element 0
        bytes32 slot = vm.load(address(storagePacking), base);

        // Unpack the values from the single storage slot
        uint128 a = uint128(uint256(slot) & ((1 << 128) - 1));
        uint64 b = uint64((uint256(slot) >> 128) & ((1 << 64) - 1));
        uint64 c = uint64((uint256(slot) >> 192) & ((1 << 64) - 1));

        assertEq(a, 11);
        assertEq(b, 22);
        assertEq(c, 33);
    }

    function test_Packed_StorageSlots2() public {
        storagePacking.writePacked(11, 22, 33);

        // Base slot of packedArray = 1
        bytes32 base = keccak256(abi.encode(uint256(1)));

        bytes32 slot = vm.load(address(storagePacking), base);

        // Decode packed values manually
        uint128 a = uint128(uint256(slot));
        uint64 b = uint64(uint256(slot >> 128));
        uint64 c = uint64(uint256(slot >> 192));

        assertEq(a, 11);
        assertEq(b, 22);
        assertEq(c, 33);
    }
}
