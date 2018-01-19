Smart Contracts
===============

# Installation
Follow the steps below for installing all necessary tools 
to develop smart contracts:

* Install the solidity compiler: `npm install -g solc@0.4.19`
* Install `ganache-cli` (aka TestRPC): `npm install -g ganache-cli`
* Install `truffle`: `npm install -g truffle@4.0.5`  

# Development

* Start `ganache-cli`
* Compile contracts: `truffle compile --all`
* Migrate contracts: `truffle migrate`
* Run tests: `truffle test`

To access the contracts, use `truffle console` in order to get into the console.

