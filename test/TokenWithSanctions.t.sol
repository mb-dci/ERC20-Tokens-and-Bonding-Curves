// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {tokenWithSanctions} from "../src/TokenWithSanctions.sol";

contract tokenWithSanctionsHarness is tokenWithSanctions(0x17F6AD8Ef982297579C203069C1DbfFE4348c372) {
    function exposed_mint(address to, uint256 amount) external {
        return _mint(to, amount);
    }
}

contract tokenWithSanctionsTest is Test {
    tokenWithSanctionsHarness public tokenWithSanctionsContract;

    address bannedAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address regularAddress = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    function setUp() public {
        tokenWithSanctionsContract = new tokenWithSanctionsHarness();
        tokenWithSanctionsContract.exposed_mint(bannedAddress, 1);
        tokenWithSanctionsContract.exposed_mint(regularAddress, 2);
    }

    function testbanAddress() public {
        vm.prank(0x17F6AD8Ef982297579C203069C1DbfFE4348c372);
        tokenWithSanctionsContract.banAddress(bannedAddress);
        vm.prank(regularAddress);
        vm.expectRevert();
        tokenWithSanctionsContract.transfer(bannedAddress, 1);
    }
}
