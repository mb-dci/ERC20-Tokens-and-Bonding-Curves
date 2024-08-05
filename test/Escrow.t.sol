// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Escrow} from "../src/Escrow.sol";
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract EscrowTest is Test {
    Escrow public escrow;
    IERC20 public mockIERC20Contract;

    address buyer = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address seller = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address mockERC20Contract_addr;

    function setUp() public {
        escrow = new Escrow();
        mockIERC20Contract = IERC20(address(0xab8483F64d9c6d1ecf9B849aE677Dd3315835cB3));
        mockERC20Contract_addr = address(mockIERC20Contract);
    }

    function testDepositAndWithdraw() public {
        vm.mockCall(mockERC20Contract_addr, abi.encodeWithSelector(ERC20.transferFrom.selector), abi.encode(true));
        vm.prank(buyer);
        uint256 deposit_id = escrow.deposit(mockIERC20Contract, 2, seller);
        assertEq(deposit_id, 1);

        // withdraw within lock-up period
        vm.mockCall(mockERC20Contract_addr, abi.encodeWithSelector(ERC20.transfer.selector), abi.encode(true));

        vm.prank(seller);
        vm.expectRevert();
        escrow.withdraw(deposit_id);

        // withdraw after lock-up period
        skip(4 days);
        vm.prank(seller);
        escrow.withdraw(deposit_id);
    }

    function testCancel() public {
        // deposit
        vm.mockCall(mockERC20Contract_addr, abi.encodeWithSelector(ERC20.transferFrom.selector), abi.encode(true));
        vm.prank(buyer);
        uint256 depositId = escrow.deposit(mockIERC20Contract, 2, seller);
        assertEq(depositId, 1);

        // cancel
        vm.mockCall(mockERC20Contract_addr, abi.encodeWithSelector(ERC20.transfer.selector), abi.encode(true));
        vm.prank(buyer);
        escrow.cancel(1);
    }
}
