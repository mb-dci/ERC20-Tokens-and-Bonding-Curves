// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title A token contract with sanctions functionality
 * @notice This is an ERC20 contract that allows for specified addresses
 * to be banned from sending and recieving tokens.
 */
contract tokenWithSanctions is ERC20("tokenWithSanctions", "TKS"), Ownable2Step {
    mapping(address => bool) bannedAddresses;

    /**
     * @dev Set owner of contract who can ban and unban addresses.
     */
    constructor(address _owner) Ownable(_owner) {}

    /**
     * @dev Add an address to the sanctions list.
     */
    function banAddress(address wallet) external onlyOwner {
        bannedAddresses[wallet] = true;
    }

    /**
     * @dev Remove an address from the sanctions list.
     */
    function unBanAddress(address wallet) external onlyOwner {
        bannedAddresses[wallet] = false;
    }

    /**
     * @dev Setting a require before the super._update() function is called enables this contract to limit
     * any transfer, transferFrom, mint, or burn to or from any banned addresses.
     */
    function _update(address from, address to, uint256 value) internal override {
        require(!bannedAddresses[from] && !bannedAddresses[to], "transfer to or from banned address");
        super._update(from, to, value);
    }
}
