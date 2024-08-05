// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title A token contract with sanctions functionality
 * @notice This is an ERC20 contract that allows for specified addresses
 * to be banned from sending and recieving tokens.
 */
contract tokenWithSanctions is ERC20("tokenWithSanctions", "TKS") {
    mapping(address => bool) bannedAddresses;

    /**
     * @dev Add an address to the sanctions list.
     */
    function banAddress(address wallet) external {
        bannedAddresses[wallet] = true;
    }

    /**
     * @dev Remove an address from the sanctions list.
     */
    function unBanAddress(address wallet) external {
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
