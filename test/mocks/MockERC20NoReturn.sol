// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Mock USDT style ERC20 (NO return value)
contract MockERC20NoReturn {
    mapping(address => uint) public balanceOf;

    constructor() {
        balanceOf[msg.sender] = 1000 ether;
    }

    // no return value
    function transfer(address to, uint value) external {
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        // no return
    }
}