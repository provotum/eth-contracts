var Ballot = artifacts.require("./Ballot.sol");
var ZeroKnowledgeVerificator = artifacts.require("./ZeroKnowledgeVerificator.sol");

module.exports = function (deployer, network, accounts) {
    deployer.deploy(ZeroKnowledgeVerificator);

    deployer.then(function () {
        return ZeroKnowledgeVerificator.new();
    }).then(function (zkVerificator) {
        deployer.link(ZeroKnowledgeVerificator, Ballot);

        deployer.deploy(Ballot, 'Do you agree?', zkVerificator.address);
    });
};
