var Migrations = artifacts.require("./Migrations.sol");

// deploy migrations contract
module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
