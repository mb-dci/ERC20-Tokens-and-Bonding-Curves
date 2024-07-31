// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title An escrow contract
/// @author Mohammed Ali Baig
/// @notice A contract where a buyer can put an arbitrary ERC20 token into escrow and a seller can withdraw it 3 days later
contract Escrow {
    /// @dev A new deposit_id is generated for each deposit into the escrow contract. For a given deposit_id, the following parameters
    /// @dev are recoreded:
    /// @dev each deposit into the escrow contract is assigned a deposit_id, the seller must specify to the withdraw function which deposit_id there are attempting to collect tokens from.
    uint256 deposit_id;
    /// @dev deposit_id -> buyer, the address of buyer who created this deposit
    mapping(uint256 => address) internal buyers;
    /// @dev deposit_id -> seller, the address that is allowed to withdraw the tokens after the lockout period
    mapping(uint256 => address) internal sellers;
    /// @dev deposit_id -> amount, the amount of tokens the buyer deposited for the seller to withdraw
    mapping(uint256 => uint256) internal amounts;
    /// @dev deposit_id -> due, the timestamp after which the seller will be able to withdraw the deposited tokens
    mapping(uint256 => uint256) internal due;
    /// @dev deposit_id -> token, the ERC20 contract address of the tokens for this particalular deposit
    mapping(uint256 => address) internal token;

    function deposit(address ERC20Contract, uint256 amount, address seller) public returns (uint256) {
        // check approval on ERC20Contract
        (bool ok, bytes memory result) =
            ERC20Contract.call(abi.encodeWithSignature("allowance(address,address)", msg.sender, address(this)));
        require(ok, "check approval call failed");
        uint256 approvedAmount = abi.decode(result, (uint256));
        require(approvedAmount >= amount, "not approved for correct amount");

        // transfer tokens to escrow
        (bool ok2,) = ERC20Contract.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), amount)
        );
        require(ok2, "transfer from buyer to escrow failed");

        // Set mappings
        deposit_id++;
        buyers[deposit_id] = msg.sender;
        amounts[deposit_id] = amount;
        token[deposit_id] = ERC20Contract;
        sellers[deposit_id] = seller;
        due[deposit_id] = block.timestamp + 3 days;

        return deposit_id;
    }

    function withdraw(uint256 id) public {
        require(block.timestamp > due[id], "escrow still within lock-up period");
        require(msg.sender == sellers[id], "wrong withdrawer");

        // transfer tokens from escrow to seller
        (bool ok,) = token[id].call(abi.encodeWithSignature("transfer(address,uint256)", msg.sender, amounts[id]));
        require(ok, "transfer to seller from escrow failed");

        //zero out mappings
        buyers[id] = address(0);
        amounts[id] = 0;
        sellers[id] = address(0);
        due[id] = 0;
        token[id] = address(0);
    }
}