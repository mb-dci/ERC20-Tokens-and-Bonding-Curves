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
}
