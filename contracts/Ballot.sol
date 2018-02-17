pragma solidity ^0.4.18;


import {ZeroKnowledgeVerificator as ZeroKnowledgeVerificator} from "./ZeroKnowledgeVerificator.sol";


/**
* @title A contract representing a single ballot for a particular vote resp. election.
*/
contract Ballot {

    event VoteEvent(address indexed _from, bool wasSuccessful, string reason);
    event ChangeEvent(address indexed _from, bool wasSuccessful, string reason);

    modifier onlyOwner {
        require(msg.sender == _owner);
        // code for the function modified is inserted at _
        _;
    }

    struct Voter {
        address voter;
        string ciphertext;
        string proof;
    }

    struct Proposal {
        uint nrVoters;
        mapping(address => bool) voted;
        Voter[] voters;
        string question;
    }

    address private _owner;

    bool private _votingIsOpen;

    Proposal private _proposal;


    ZeroKnowledgeVerificator _zkVerificator;

    /**
     * @param question The question the voters are getting asked.
     */
    function Ballot(string question, ZeroKnowledgeVerificator zkVerificator) public {
        _votingIsOpen = false;

        _proposal.question = question;
        _proposal.voters.length = 0;
        _proposal.nrVoters = 0;

        _zkVerificator = zkVerificator;

        _owner = msg.sender;
    }

    /**
     * @dev Opens the voting process. Only the owner of this contract is allowed to call this method.
     */
    function openVoting() external onlyOwner {
        ChangeEvent(msg.sender, true, "Opened voting");
        _votingIsOpen = true;
    }

    /**
     * @dev Closes the voting process. Only the owner of this contract is allowed to call this method.
     */
    function closeVoting() external onlyOwner {
        ChangeEvent(msg.sender, true, "Closed voting");
        _votingIsOpen = false;
    }

    /**
     * Consider the ElGamal multiplicative (i.e. additive homomorphic) encryption to be of the form:
     *
     *   E(m) = (G, H) = (g^r, h^r * g^m), with h = g^x and m = message
     *
     * @dev Note, this function does not assume anything about how the ciphertext resp. the proof
     * is actually represented. This is the domain of the caller.
     *
     * @param ciphertext   The ciphertext, i.e. a string representing (G, H)
     * @param proof        The corresponding membership proof.
     *
     * @return bool, string True if vote is accepted, false otherwise, along with the reason why.
     */
    function vote(string ciphertext, string proof) external returns (bool, string) {
        // check whether voting is still allowed
        if (!_votingIsOpen) {
            VoteEvent(msg.sender, false, "Voting is closed");
            return (false, "Voting is closed");
        }

        bool hasVoted = _proposal.voted[msg.sender];
        // disallow multiple votes
        if (hasVoted) {
            VoteEvent(msg.sender, false, "Voter already voted");
            return (false, "Voter already voted");
        }

        bool validZkProof = _zkVerificator.verifyProof(proof);
        if (!validZkProof) {
            VoteEvent(msg.sender, false, "Invalid zero knowledge proof");
            return (false, "Invalid zero knowledge proof");
        }

        _proposal.voted[msg.sender] = true;
        _proposal.voters.push(Voter({voter : msg.sender, ciphertext : ciphertext, proof : proof}));

        _proposal.nrVoters += 1;

        VoteEvent(msg.sender, true, "Accepted vote");

        return (true, "Accepted vote");
    }

    /**
     * @dev Returns the question to ask voters, set on construction of this contract.
     *
     * @return question The question to ask voters.
     */
    function getProposedQuestion() public constant returns (string question) {
        question = _proposal.question;
    }

    /**
     * @dev Returns the total number of voters which have currently voted.
     *
     * @return totalVotes The total number of voters which have currently voted.
     */
    function getTotalVotes() public constant returns (uint totalVotes) {
        totalVotes = _proposal.nrVoters;
    }

    /**
     * @dev Returns the vote submitted by the voter at the given index.
     *
     * @return voter        The address of the voter.
     * @return ciphertext   The ciphertext.
     * @return proof        The proof.
     */
    function getVote(uint index) external constant returns (address voter, string ciphertext, string proof) {
        return (_proposal.voters[index].voter, _proposal.voters[index].ciphertext, _proposal.voters[index].proof);
    }

    /**
     * @dev Destroys this contract. May be called only by the owner of this contract.
     */
    function destroy() public onlyOwner {
        ChangeEvent(msg.sender, true, "Destroyed contract");
        selfdestruct(_owner);
    }

}
