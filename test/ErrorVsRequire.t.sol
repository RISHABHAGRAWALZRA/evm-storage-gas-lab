// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ErrorsVsRequire} from "../contracts/ErrorsVsRequire.sol";
import {ZeroValue} from "../contracts/ErrorsVsRequire.sol";

contract ErrorsVsRequireTest is Test {
    ErrorsVsRequire e;

    function setUp() public {
        e = new ErrorsVsRequire();
    }

    function test_Gas_requireCheck() public {
        uint256 gasStart = gasleft();
        try e.requireCheck(0) {
            fail();
        } catch {
            uint256 gasUsed = gasStart - gasleft();
            emit log_named_uint("require string revert gas", gasUsed);
        }
    }

    function test_Gas_errorCheck() public {
        uint256 gasStart = gasleft();
        try e.errorCheck(0) {
            fail();
        } catch {
            uint256 gasUsed = gasStart - gasleft();
            emit log_named_uint("custom error revert gas", gasUsed);
        }
    }

    function test_ErrorSelector() public {
        bytes4 selector = ZeroValue.selector;
        emit log_bytes32(selector);
    }
}
