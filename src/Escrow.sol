// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title An ERC20 Escrow contract.
 * @notice A contract showcasing how the ERC20 standard can be used to allow a buyer
 * to put an arbitrary ERC20 token into escrow and alow a seller to withdraw it 3 days later.
 */
contract Escrow {
    using SafeERC20 for IERC20;

    /**
     * @dev A new deposit_id is generated for each deposit into the escrow contract.
     */
    uint256 deposit_id;

    /**
     * @dev The following parameters are recored in a struct for each deposit into the escrow contract:
     * @dev buyer, the address of buyer who created this deposit.
     * @dev seller, the address that is allowed to withdraw the tokens after the lockout period.
     * @dev amount, the amount of tokens the buyer deposited for the seller to withdraw.
     * @dev due, the timestamp after which the seller will be able to withdraw the deposited tokens.
     * @dev token, the ERC20 contract address of the tokens for this particalular deposit.
     */
    struct Deposit {
        address buyer;
        address seller;
        uint256 amount;
        uint256 due;
        IERC20 token;
    }

    /**
     * @dev The mapping that holds the deposit_id to Deposit struct relationship.
     */
    mapping(uint256 => Deposit) public depositsMapping;

    /**
     * @dev A buyer will call the deposit function and specifiy which type of token they are depositing,
     * the amount of the token, and the address of person who can withdraw the funds three days later.
     *
     * The function will return a deposit_id which must be passed onto to the seller so that they can
     * withdraw the funds later.
     */
    function deposit(IERC20 ERC20Contract, uint256 amount, address seller) public returns (uint256) {
        // transfer tokens from depositor to escrow
        SafeERC20.safeTransferFrom(ERC20Contract, msg.sender, address(this), amount);

        deposit_id++;
        depositsMapping[deposit_id] = Deposit({
            buyer: msg.sender,
            seller: seller,
            amount: amount,
            due: block.timestamp + 3 days,
            token: ERC20Contract
        });

        return deposit_id;
    }

    /**
     * @dev After the three day waiting period, the seller can call the withdraw() function specifying
     * a particular deposit_id from which to withdraw the funds.
     */
    function withdraw(uint256 id) public {
        require(block.timestamp > depositsMapping[id].due, "escrow still within lock-up period");
        require(msg.sender == depositsMapping[id].seller, "wrong withdrawer");

        Deposit memory temp = depositsMapping[id];
        //zero out mapping
        depositsMapping[id] =
            Deposit({buyer: address(0), seller: address(0), amount: 0, due: 0, token: IERC20(address(0))});

        // transfer tokens from escrow to withdrawer
        SafeERC20.safeTransfer(temp.token, msg.sender, temp.amount);
    }

    /**
     * @dev The depositor may at anytime cancel their deposit into the escrow and have their funds
     * returned to them.
     */
    function cancel(uint256 id) public {
        require(msg.sender == depositsMapping[id].buyer, "only buyer can cancel");

        Deposit memory temp = depositsMapping[id];

        depositsMapping[id] =
            Deposit({buyer: address(0), seller: address(0), amount: 0, due: 0, token: IERC20(address(0))});

        // transfer tokens back to buyer
        SafeERC20.safeTransfer(temp.token, msg.sender, temp.amount);
    }
}
