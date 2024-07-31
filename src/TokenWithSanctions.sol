// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title A token contract with sanctions functionality 
/// @author Mohammed Ali Baig
/// @notice This is an ERC20 contract that allows for specified addresses to be banned from sending and recieving tokens
contract tokenWithSanctions is ERC20("tokenWithSanctions", "TKS") {

    mapping (address => bool) bannedAddresses;

    function banAddress (address wallet) external {
        bannedAddresses[wallet] = true;
    }

    function unBanAddress (address wallet) external {
        bannedAddresses[wallet] = false;
    }

    function _update(address from, address to, uint256 value) internal override {
        require(!bannedAddresses[from] && !bannedAddresses[to], "transfer to or from banned address");
        super._update(from, to, value);
    }
}