// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

/**
 * @title ERC20 Bonding Curve token contract.
 * @notice  A token contract with a linear bonding curve to determine the price of the tokens.
 */
contract BondingCurveToken is ERC20("TokenSale", "TKS") {
    /**
     * @dev Mint tokens to the user based on the current price of the tokens.
     */
    function mint() public payable {
        uint256 tokensToBeMinted = tokensToMint(msg.value);
        super._mint(msg.sender, tokensToBeMinted);
    }

    /**
     * @dev Burn tokens that the user has sent in and return Ether based on the current price of the tokens.
     */
    function burn(uint256 tokensToBurn) public {
        uint256 etherRefund = etherToReturn(tokensToBurn);
        super._burn(msg.sender, tokensToBurn);
        msg.sender.call{value: etherRefund}("");
    }

    /**
     * @dev Based on the amount of ether the user has sent this function will
     * determine the tokens to be minted through the linear bonding curve equation.
     */
    function tokensToMint(uint256 amountOfEtherPaid) public view returns (uint256) {
        uint256 collateralBalance = (totalSupply() ** 2) / 2e18;
        uint256 tokenToBeMinted = Math.sqrt((2e18 * (amountOfEtherPaid + collateralBalance))) - totalSupply();
        return tokenToBeMinted;
    }

    /**
     * @dev Calculate the amount of ether to return to the user based on how much tokens they are burning
     * and the current price of the tokens.
     */
    function etherToReturn(uint256 amountOfTokensToBurn) public view returns (uint256) {
        uint256 collateralBalance = (totalSupply() ** 2) / 2e18;
        uint256 etherToBeReturned = collateralBalance - ((totalSupply() - amountOfTokensToBurn) ** 2) / 2e18;
        return etherToBeReturned;
    }
}
