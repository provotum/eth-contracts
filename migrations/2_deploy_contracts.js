var Ballot = artifacts.require("./Ballot.sol");
var ZeroKnowledgeVerificator = artifacts.require("./ZeroKnowledgeVerificator.sol");
var SignatureVerificator = artifacts.require("./SignatureVerificator.sol");

module.exports = function (deployer, network, accounts) {
    deployer.deploy(ZeroKnowledgeVerificator);
    deployer.deploy(SignatureVerificator);

    var zkVerificator;
    var signatureVerificator;
    deployer.then(function () {
        return ZeroKnowledgeVerificator.new();
    }).then(function (_zkVerificator) {
        zkVerificator = _zkVerificator;

        return SignatureVerificator.new();
    }).then(function (_signatureVerifiator) {
        signatureVerificator = _signatureVerifiator;

        deployer.link(ZeroKnowledgeVerificator, Ballot);
        deployer.link(SignatureVerificator, Ballot);

        deployer.deploy(Ballot, 'Do you agree?', signatureVerificator.address, zkVerificator.address);
    });
};
