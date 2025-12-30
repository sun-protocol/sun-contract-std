// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Mock standard ERC20 (returns true)
contract MockERC20ReturnFalse {
    function transfer(address to, uint value) external returns (bool) {
        return false;
    }
}