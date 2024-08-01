// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {BondingCurveToken} from "../src/BondingCurveToken.sol";

contract BondingCurveTokenTest is Test {
    BondingCurveToken public bondingCurveToken;

    function setUp() public {
        bondingCurveToken = new BondingCurveToken();
    }

    function normalCalcTest() public {
        uint256 amount = bondingCurveToken.normalCalc(1);
        console.log("amount: ", amount);
    }
}
