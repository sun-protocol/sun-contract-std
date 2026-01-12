// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "forge-std/Test.sol";
import "../contracts/libraries/SafeTransferLib.sol";
import "./TokenSender.sol";

import "./mocks/MockERC20Standard.sol";
import "./mocks/MockERC20NoReturn.sol";
import "./mocks/MockERC20Revert.sol";
import "./mocks/MockERC20ReturnFalse.sol";

contract SafeTransferTest is Test {
    TokenSender sender;
    MockERC20Standard tokenStd;
    MockERC20NoReturn tokenNoRet;
    MockERC20Revert tokenRevert;
    MockERC20ReturnFalse tokenReturnFalse;

    address alice = address(0x1234);

    function setUp() public {
        sender = new TokenSender();
        tokenStd = new MockERC20Standard();
        tokenNoRet = new MockERC20NoReturn();
        tokenRevert = new MockERC20Revert();
        tokenReturnFalse = new MockERC20ReturnFalse();

        tokenStd.transfer(address(sender), 100 ether);
        tokenNoRet.transfer(address(sender), 100 ether);
    }

    function test_StandardERC20() public {
        // give TokenSender approval (skip for simplicity)
        vm.prank(address(tokenStd));
        tokenStd.balanceOf(address(this)); // just to silence warnings

        bool ok = sender.send(address(tokenStd), alice, 10 ether);
        assertTrue(ok, "Standard ERC20 should return true");

        assertEq(tokenStd.balanceOf(alice), 10 ether);
    }

    function test_USDTStyle() public {
        bool ok = sender.send(address(tokenNoRet), alice, 10 ether);
        assertTrue(ok, "USDT-style token w/o return should still be treated as success");

        assertEq(tokenNoRet.balanceOf(alice), 10 ether);
    }

    function test_BrokenTokenReverts() public {
        // no code at fakeToken → call() returns success=false
        bool ok = sender.send(address(tokenRevert), alice, 10 ether);

        assertFalse(ok, "Sending with non-contract token must fail");
    }

    function test_NileUsdt() public {
        vm.chainId(SafeTransferLib.NILE_CHAIN_ID);
        vm.etch(SafeTransferLib.USDTNileAddr, address(tokenReturnFalse).code);
        
        bool ok = sender.send(address(SafeTransferLib.USDTNileAddr), alice, 10 ether);

        assertTrue(ok, "Nile Usdt should return success");
    }

    function test_MainUsdt() public {
        vm.chainId(SafeTransferLib.MAIN_CHAIN_ID);
        vm.etch(SafeTransferLib.USDTMainAddr, address(tokenReturnFalse).code);

        bool ok = sender.send(address(SafeTransferLib.USDTMainAddr), alice, 10 ether);

        assertTrue(ok, "Main Usdt should return success");
    }
}
