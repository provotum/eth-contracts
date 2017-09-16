pragma solidity ^0.4.15;


/**
 * @title A contract verifying submitted votes for a valid signature.
 */
contract SignatureVerificator {

    modifier onlyOwner {
        require(msg.sender == _owner);
        // code for the function modified is inserted at _
        _;
    }

    address private _owner;

    function SignatureVerificator() public {
        _owner = msg.sender;
    }

    /**
     * @dev Verifies the signature of the given vote.
     *
     * @param vote The vote to verify its signature.
     *
     * @return True, if the signature is valid, false otherwise.
     */
    function verifySignature(string vote) external constant returns (bool) {
        // TODO: check signature
        return true;
    }

    /**
     * @dev Destroys this contract. May be called only by the owner of this contract.
     */
    function destroy() onlyOwner {
        selfdestruct(_owner);
    }
}