var Proxy = artifacts.require("./Proxy.sol");

module.exports = function (deployer, network, accounts) {

  // deploy the proxy contract only
  deployer.deploy(Proxy);

  deployer.then(function () {
    // do not delete this line. It is used in the setup script for grepping the proxy's address.
    console.log("Proxy contract is deployed at " + Proxy.address);
  });
};
