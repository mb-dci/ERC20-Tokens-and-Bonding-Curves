## ERC20 Tokens and Bonding Curves

This repo contains a set of four Solidity smart contracts that make use of the ERC20 token standard. They are intended to be gas efficient implementations and safegaurd against known smart contract anti-patterns. 
- [ ]  **Solidity contract 1:** ERC20 with sanctions. An ERC20 token that allows an admin to ban specified addresses from sending and receiving tokens.
- [ ]  **Solidity contract 2:** ERC20 with god mode. A special address is able to transfer tokens between addresses at will.
- [ ]  **Solidity contract 3:** ERC20 bonding curve token. The more tokens a user buys, the more expensive the token becomes.
- [ ]  **Solidity contract 4:** Untrusted escrow. A contract where a buyer can put an arbitrary ERC20 token into a contract and a seller can withdraw it 3 days later.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```
