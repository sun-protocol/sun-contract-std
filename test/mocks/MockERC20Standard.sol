// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Mock standard ERC20 (returns true)
contract MockERC20Standard {
    mapping(address => uint) public balanceOf;

    constructor() {
        balanceOf[msg.sender] = 1000 ether;
    }

    function transfer(address to, uint value) external returns (bool) {
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        return true;
    }
}