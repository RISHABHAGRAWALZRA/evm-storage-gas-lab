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

## Memory Vs Calldata

🔹 Memory (Mutable):

 1. Data is copied from calldata into memory and ABI decode calldata
 2. Allocate memory
 3. Copy calldata → memory
 4. Loop over memory (MLOAD)
 5. Memory expansion cost

🔹 Calldata (read only/Immutable):

 1. ABI decode references
 2. Loop directly over calldata (CALLDATALOAD)
 3. No memory growth

## Error Vs Require

### ABI encoding

#### Revert String

```go
Error(string)
→ selector + offset + length + string bytes
```

require("string")

- Stores string literal in bytecode
- ABI-encodes the string at runtime
- Larger deployment bytecode
- Higher revert gas

#### Custom Error

```go
ErrorName(type1,type2)
→ selector + encoded args
```

revert CustomError()

- Stores error selector only
- Encodes arguments (if any)
- No string storage
- Much smaller bytecode
- Cheaper runtime revert
