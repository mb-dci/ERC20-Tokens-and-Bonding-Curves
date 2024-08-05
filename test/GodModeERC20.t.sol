// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {tokenWithGodMode} from "../src/GodModeERC20.sol";

address constant specialAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;

contract tokenWithGodModeHarness is tokenWithGodMode(specialAddress) {
    function exposed_mint(address to, uint256 amount) external {
        return _mint(to, amount);
    }
}

contract tokenWithGodModeTest is Test {
    tokenWithGodModeHarness public tokenWithGodModeContract;

    address to = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address from = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    function setUp() public {
        tokenWithGodModeContract = new tokenWithGodModeHarness();
        tokenWithGodModeContract.exposed_mint(from, 1);
    }

    function testTransferGodMode() public {
        vm.prank(specialAddress);
        bool ok = tokenWithGodModeContract.transferGodMode(from, to, 1);
        assertEq(ok, true);
    }
}
