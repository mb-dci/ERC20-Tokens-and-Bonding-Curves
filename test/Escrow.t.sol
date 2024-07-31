// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Escrow} from "../src/Escrow.sol";
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract EscrowTest is Test {
    Escrow public escrow;

    address buyer = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address seller = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address mockERC20Contract = 0xE0f992C2dAC5A9210fE5265ACAB51a023Ed39218;

    function setUp() public {
        escrow = new Escrow();
    }

    function testDepositAndWithdraw() public {
        vm.mockCall(
            mockERC20Contract, 
            abi.encodeWithSelector(ERC20.allowance.selector), 
            abi.encode(10)
        );
        vm.mockCall(
            mockERC20Contract,
            abi.encodeWithSelector(ERC20.transferFrom.selector),
            abi.encode(true)
        );
        vm.prank(buyer);
        uint256 deposit_id = escrow.deposit(mockERC20Contract, 2, seller);
        assertEq(deposit_id, 1);

        // withdraw within lock-up period
        vm.mockCall(
            mockERC20Contract,
            abi.encodeWithSelector(ERC20.transfer.selector),
            abi.encode(true))
        ;
        vm.prank(seller);
        vm.expectRevert();
        escrow.withdraw(deposit_id);

        // withdraw after lock-up period
        skip(4 days);
        vm.prank(seller);
        escrow.withdraw(deposit_id);
    }
  
}

