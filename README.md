Smart Contracts
===============

# Installation
Follow the steps below for installing all necessary tools 
to develop smart contracts:

* Install the solidity compiler: `npm install -g solc@0.4.19`
* Install `ganache-cli` (aka TestRPC): `npm install -g ganache-cli`
* Install `truffle`: `npm install -g truffle@4.0.5`

# Information

## Unlock Account and get Balance

Attach to your running `geth` node:  `geth attach ipc://Users/Raphael/Library/Ethereum/testnet/geth.ipc`

```javascript
    web3.personal.unlockAccount(web3.eth.accounts[2])
    //> Unlock account 0xda8dc0aed975b0a62e8ad7aa164039e80b7bfce7
    //> Passphrase:
    //< true
    web3.eth.getBalance(web3.eth.accounts[2])
```  

# Development

* Start `ganache-cli`
* Compile contracts: `truffle compile --all`
* Migrate contracts: `truffle migrate`
* Run tests: `truffle test`

To access the contracts, use `truffle console` in order to get into the console.

