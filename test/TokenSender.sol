// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../contracts/libraries/SafeTransferLib.sol";

contract TokenSender {
    using SafeTransferLib for address;

    function send(address token, address to, uint value) external returns (bool) {
        return token.safeTransfer(to, value);
    }
}
