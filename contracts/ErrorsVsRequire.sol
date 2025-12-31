// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

error ZeroValue();
error NotOwner(address caller);

contract ErrorsVsRequire {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function requireCheck(uint256 x) external pure {
        require(x > 0, "x must be greater than zero");
    }

    function errorCheck(uint256 x) external pure {
        if (x == 0) {
            revert ZeroValue();
        }
    }

    function requireOwner() external view {
        require(msg.sender == owner, "not owner");
    }

    function errorOwner() external view {
        if (msg.sender != owner) {
            revert NotOwner(msg.sender);
        }
    }
}
