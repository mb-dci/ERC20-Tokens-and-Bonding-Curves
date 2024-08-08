// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title A token contract with the ability for the contract owner to transfer tokens at-will
 * @notice This is an ERC20 contract that allows for a specified addresses to move tokens
 * around in the ledger at will.
 */
contract tokenWithGodMode is ERC20("tokenWithGodMode", "TKG"), Ownable2Step {
    /**
     * @dev Set owner of contract who can conduct transfers between accounts at will
     */
    constructor(address _owner) Ownable(_owner) {}

    /**
     * @dev This function allows for the owner to transfer, transferFrom, mint, or
     * burn to or from any address.
     */
    function transferGodMode(address from, address to, uint256 value) public onlyOwner {
        super._update(from, to, value);
    }
}
