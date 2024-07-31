// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title A token contract with the ability for a specific address to transfer tokens at will
/// @author Mohammed Ali Baig
/// @notice This is an ERC20 contract that allows for a specified addresses to move tokens around in the ledger at will.
contract tokenWithGodMode is ERC20("tokenWithGodMode", "TKG") {

    address special_address;

    constructor(address _special_address) payable {
        special_address = _special_address;
    }

    function transferGodMode(address from, address to, uint256 value) public returns (bool) {
        require(msg.sender == special_address, "Only special address may call this function");
        super._update(from, to, value);
        return true;
    }
}