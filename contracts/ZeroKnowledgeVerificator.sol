pragma solidity ^0.4.15;


/**
 * @title A contract verifying a zero-knowledge proof.
 */
contract ZeroKnowledgeVerificator {

    modifier onlyOwner {
        require(msg.sender == _owner);
        // code for the function modified is inserted at _
        _;
    }

    address private _owner;

    function ZeroKnowledgeVerificator() {
        _owner = msg.sender;
    }

    /**
     * @dev Verify the zero-knowledge proof of the given vote.
     *
     * @param vote The vote to verify.
     *
     * @return True, if the vote has been verified successfully, false otherwise.
     */
    function verifyProof(string vote) external constant returns (bool) {
        // TODO: verify proof

        return true;
    }

    /**
     * @dev Destroys this contract. May be called only by the owner of this contract.
     */
    function destroy() onlyOwner {
        selfdestruct(_owner);
    }
}
