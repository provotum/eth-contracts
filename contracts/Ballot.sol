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
        string bigG;
        string bigH;
        string p;
        string y;
        string z;
        string s;
        string c;
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
     *
     * @param bigG A string representing G of the ElGamal ciphertext.
     * @param bigH A string representing H of the ElGamal ciphertext.
     * @param p    A string representing the prime modulus used in the ciphertext and in the proof.
     * @param y    A concatenated string of y-values of the proof, delimited by the character Y.
     * @param z    A concatenated string of z-values of the proof, delimited by the character Z.
     * @param s    A concatenated string of s-values of the proof, delimited by the character S.
     * @param c    C concatenated string of c-values of the proof, delimited by the character C.
     *
     * @return bool, string True if vote is accepted, false otherwise, along with the reason why.
     */
    function vote(string bigG, string bigH, string p, string y, string z, string s, string c) external returns (bool, string) {
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

        bool validZkProof = _zkVerificator.verifyProof(chosenVote);
        if (!validZkProof) {
            VoteEvent(msg.sender, false, "Invalid zero knowledge proof");
            return (false, "Invalid zero knowledge proof");
        }

        Voter memory sender = Voter({voter : msg.sender, bigG: bigG, bigH: bigH, p:p, y:y, z:z, s:s, c:c});
        _proposal.voted[msg.sender] = true;
        _proposal.voters.push(sender);

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
     * @return voter The address of the voter.
     * @return bigG A string representing G of the ElGamal ciphertext.
     * @return bigH A string representing H of the ElGamal ciphertext.
     * @return p    A string representing the prime modulus used in the ciphertext and in the proof.
     * @return y    A concatenated string of y-values of the proof, delimited by the character Y.
     * @return z    A concatenated string of z-values of the proof, delimited by the character Z.
     * @return s    A concatenated string of s-values of the proof, delimited by the character S.
     * @return c    C concatenated string of c-values of the proof, delimited by the character C.
     */
    function getVote(uint index) external constant returns (address voter, string bigG, string bigH, string p, string y, string z, string s, string c) {
        return (_proposal.voters[index].voter, _proposal.voters[index].bigG, _proposal.voters[index].bigH, _proposal.voters[index].p, _proposal.voters[index].y, _proposal.voters[index].z, _proposal.voters[index].s, _proposal.voters[index].c);
    }

    /**
     * @dev Destroys this contract. May be called only by the owner of this contract.
     */
    function destroy() public onlyOwner {
        ChangeEvent(msg.sender, true, "Destroyed contract");
        selfdestruct(_owner);
    }

}
