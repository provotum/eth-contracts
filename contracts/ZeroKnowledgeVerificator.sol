pragma solidity ^0.4.18;


/**
 * @title A contract verifying a zero-knowledge proof.
 */
contract ZeroKnowledgeVerificator {

    event ProofEvent(address indexed _from, bool wasSuccessful, string reason);

    modifier onlyOwner {
        require(msg.sender == _owner);
        // code for the function modified is inserted at _
        _;
    }

    address private _owner;


    function ZeroKnowledgeVerificator() public {
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
        ProofEvent(msg.sender, true, "Proof was successful");

        return true;
    }

    /**
     * @dev Destroys this contract. May be called only by the owner of this contract.
     */
    function destroy() public onlyOwner {
        selfdestruct(_owner);
    }
}
