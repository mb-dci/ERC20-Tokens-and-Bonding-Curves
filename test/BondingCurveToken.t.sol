// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {BondingCurveToken} from "../src/BondingCurveToken.sol";
import {UD60x18, ud60x18, ud, convert} from "@prb/math/src/UD60x18.sol";

contract BondingCurveTokenTest is Test {
    BondingCurveToken public bondingCurveToken;
    address user = makeAddr("user");

    function setUp() public {
        bondingCurveToken = new BondingCurveToken();
        vm.deal(user, 5 ether);
    }

    function testCalc() public {
        vm.startPrank(user);
        console.log("--------Mint()");
        bondingCurveToken.mint{value: 0.5 ether}();
        console.log("After mint balanceOf user1: ", bondingCurveToken.balanceOf(user));
        console.log("After mint ethbalance user1", user.balance);
        console.log("Test-TotalSupply in contract: ", bondingCurveToken.totalSupply());
        console.log("--------Mint()");
        bondingCurveToken.mint{value: 1.5 ether}();
        console.log("After mint balanceOf user1: ", bondingCurveToken.balanceOf(user));
        console.log("After mint ethbalance user1", user.balance);
        console.log("Test-TotalSupply in contract: ", bondingCurveToken.totalSupply());
        console.log("--------Burn()");
        bondingCurveToken.burn(1e18);
        console.log("After burn balanceOf user1: ", bondingCurveToken.balanceOf(user));
        console.log("After burn ethbalance user1", user.balance);
        console.log("Test-TotalSupply in contract: ", bondingCurveToken.totalSupply());
        console.log("--------Burn()");
        bondingCurveToken.burn(1e18);
        console.log("After burn balanceOf user1: ", bondingCurveToken.balanceOf(user));
        console.log("After burn ethbalance user1", user.balance);
        console.log("Test-TotalSupply in contract: ", bondingCurveToken.totalSupply());
    }

    function testNonIntegerValues() public {
        vm.startPrank(user);
        console.log("--------Mint()");
        bondingCurveToken.mint{value: 0.1 ether}();
        uint256 firstTokensMinted = bondingCurveToken.balanceOf(user);
        console.log(firstTokensMinted);
        console.log("After mint1 ethbalance user1", user.balance);
        console.log("--------Mint()");
        bondingCurveToken.mint{value: 1.5 ether}();
        uint256 secondTokensMinted = bondingCurveToken.balanceOf(user) - firstTokensMinted;
        console.log(secondTokensMinted);
        console.log("After mint2 ethbalance user1", user.balance);
        console.log("--------Burn()");
        console.log("Before burn ethbalance user1", user.balance);
        uint256 beforeBurnBal = user.balance;
        bondingCurveToken.burn(447213595499957939);
        console.log("After burn ethbalance user1", user.balance);
        uint256 AmountReturned = user.balance - beforeBurnBal;
        console.log("Amount Returned: ", AmountReturned);
        console.log("--------Burn()");
        console.log("Before burn2 ethbalance user1", user.balance);
        uint256 beforeBurn2Bal = user.balance;
        bondingCurveToken.burn(1341640786499873817);
        console.log("After burn2 ethbalance user1", user.balance);
        uint256 AmountReturned2 = user.balance - beforeBurn2Bal;
        console.log("Amount Returned: ", AmountReturned2);
    }
}
