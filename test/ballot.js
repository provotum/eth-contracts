var ZeroKnowledgeVerificator = artifacts.require("./ZeroKnowledgeVerificator.sol");
var SignatureVerificator = artifacts.require("./SignatureVerificator.sol");
var Ballot = artifacts.require("./Ballot.sol");

contract('Ballot', function (accounts) {
    var sender = accounts[0];

    var zkVerificator = ZeroKnowledgeVerificator.new();
    var signatureVerificator = SignatureVerificator.new();

    var questionToVoteOn = "Do you agree?";

    it("the voting question should be the same as submitted on creation", function () {
        var ballot = Ballot.new(questionToVoteOn, signatureVerificator.address, zkVerificator.address);

        return ballot.then(function (instance) {
            // fetch vote
            return instance.getProposedQuestion.call().then(function (_question) {
                return assert.equal(questionToVoteOn, _question, "The voting question should be the same.");
            });
        });
    });

    it("should not accept any vote before being opened", function () {
        var ballot = Ballot.new(questionToVoteOn, signatureVerificator.address, zkVerificator.address);

        return ballot.then(function (instance) {
            // vote yes before vote has been opened
            return instance.vote("yes", {from: sender}).then(function () {
                // fetch all currently stored votes
                return instance.getTotalVotes.call().then(function (result) {
                    return assert.equal(0, result, "total votes should still be zero before having election opened");
                });
            });
        });
    });

});
