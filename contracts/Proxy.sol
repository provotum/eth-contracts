pragma solidity ^0.4.18;


/**
* @title A contract keeping track of the ballot contract address.
*/
contract Proxy {

    modifier onlyOwner {
        require(msg.sender == _owner);
        // code for the function modified is inserted at _
        _;
    }

    address private _owner;
    address private _ballotContractAddress;

    function Proxy() public {
        _owner = msg.sender;
    }

    /**
     * @dev Set the contract address of the ballot contract
     */
    function setAddress(address ballotContractAddress) external onlyOwner {
        _ballotContractAddress = ballotContractAddress;
    }

    /**
     * @dev Returns the current address of the ballot contract. May be undefined.
     */
    function getAddress() external constant returns (address contractAddress) {
        contractAddress = _ballotContractAddress;
    }

    /**
     * @dev Destroys this contract. May be called only by the owner of this contract.
     */
    function destroy() public onlyOwner {
        selfdestruct(_owner);
    }
}