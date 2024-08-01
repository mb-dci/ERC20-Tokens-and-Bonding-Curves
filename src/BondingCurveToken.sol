// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {UD60x18, ud60x18, ud, convert} from "@prb/math/src/UD60x18.sol";

contract BondingCurveToken is ERC20("TokenSale", "TKS") {
    event Log(UD60x18);

    function mint() public payable {
        // ---> calc function returns amount
        //super._mint(msg.sender, amount);
    }

    // @dev The contracts acceppts ETH from users and mints then a corresponding amount of Rarecoin.
    // @dev therefore, there are two pools that the contract manages, 1) ETHBalance, 2) RarecoinSupply
    // function calc(uint256 amountPaid) public returns (uint256) {
    //     // Get size of pool 1 (totalsupply of rarecoins)
    //     UD60x18 rareCoinSupply = convert(1);
    //     emit Log(rareCoinSupply);

    //     // Calculate size of pool 2 (invariant: should be equal to amount of Eth paid into the contract so far e.g address(this).balance)
    //     UD60x18 ethBalance_mid = rareCoinSupply.powu(2);
    //     emit Log(ethBalance_mid);

    //     UD60x18 ethBalance =  ethBalance_mid.div(ud(2e18));
    //     emit Log(ethBalance);

    //     // Calculate updated size of pool 2 based on amountPaid
    //     UD60x18 updatedEthBalance = ethBalance.add(ud60x18(amountPaid));
    //     emit Log(updatedEthBalance);

    //     // Extrapolate new size of pool 1 based on the increase in size of pool 2
    //     UD60x18 updatedRareCoinSupply = (updatedEthBalance.mul(UD60x18.wrap(2))).sqrt();
    //     emit Log(updatedEthBalance);

    //     // Calculate amounts of new tokens to mint for user
    //     UD60x18 mintAmount = updatedRareCoinSupply - rareCoinSupply;
    //     emit Log(mintAmount);

    //     return convert(mintAmount);
    // }

    function normalCalc(uint256 amountPaid) public returns (uint256) {
        //uint256 totalSupply = getTotalSupply();
        //uint256 totalSupply = 0;  // 0 tokens minted so far
        UD60x18 totalSupply = ud60x18(1);

        UD60x18 collateralBalance = totalSupply.powu(2).div(ud60x18(2));

        UD60x18 tokensToBeMinted = ud60x18(2).mul(ud60x18(amountPaid).add(collateralBalance)).sqrt().sub(totalSupply);

        return tokensToBeMinted.intoUint256();
    }
}
