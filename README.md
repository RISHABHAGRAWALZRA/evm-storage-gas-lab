# evm-storage-gas-lab

Experiments to understand, How solidity maps to EVM storage and Gas

## Storage Packing

### Storage layout

```go
struct Unpacked {
    uint256 a; // slot 0
    uint8 b;   // slot 1 (31 bytes wasted)
    uint256 c; // slot 2
}

// |   c (64 bits)   |   b (64 bits)   |      a (128 bits)      |
// | bits 192–255    | bits 128–191    | bits 0–127             |
struct Packed {
    uint128 a; // 16 bytes
    uint64 b;  // 8 bytes
    uint64 c;  // 8 bytes
}

// Bad version of packed struct,
struct BadPacked {
    uint64 b; // slot 0
    uint128 a; // slot 1 (32 bytes wasted)
    uint64 c; // slot 2
}
```

**Unpacked** struct used 3 slot while **Packed** used only 1 slot.

Reason: EVM packs the storage in sequentional defined order and storage is always allocated in 32-bytes slots, and it never packes across slot boundaries.

Conclusion: **uint8** does NOT mean cheap if poorly ordered

## Mapping vs Array

### Storage layout

```go
uint256[] arr // slot 0 -> array length
// Elements starts at: keccak256(abi.encode(0)) + index


mapping(uint256 => uint256) map; // slot 1
// Each value stored at: keccak256(abi.encode(key, uint256(1)))
// NO length, NO iteration and NO contiguous storage
```

Read operation for **mapping** is cheaper than **array** because

Mapping

- one hash
- one SLOAD
- No bound check

Array

- Hash for base
- Bounds check
- offset calculation
