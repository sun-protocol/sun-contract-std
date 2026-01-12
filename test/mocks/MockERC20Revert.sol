// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MockERC20Revert {
    function transfer(address, uint) external pure returns (bool) {
        revert("broken");
    }
}
