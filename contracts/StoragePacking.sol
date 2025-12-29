pragma solidity ^0.8.13;

contract StoragePacking {
    struct Unpacked {
        uint256 a;
        uint8 b;
        uint256 c;
    }

    struct Packed {
        uint128 a;
        uint64 b;
        uint64 c;
    }

    Unpacked[] unpackedArray;
    Packed[] packedArray;

    function writeUnpacked(uint256 a, uint8 b, uint256 c) public {
        unpackedArray.push(Unpacked(a, b, c));
    }

    function writePacked(uint128 a, uint64 b, uint64 c) public {
        packedArray.push(Packed(a, b, c));
    }

    function readUnpacked(
        uint index
    ) public view returns (uint256, uint8, uint256) {
        Unpacked memory temp = unpackedArray[index];
        return (temp.a, temp.b, temp.c);
    }

    function readPacked(
        uint index
    ) public view returns (uint128, uint64, uint64) {
        Packed memory temp = packedArray[index];
        return (temp.a, temp.b, temp.c);
    }
}
