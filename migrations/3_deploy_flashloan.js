var Flashloan = artifacts.require("./Flashloan.sol");

module.exports = function(deployer) {
  deployer.deploy(Flashloan, "0x987115c38fd9fd2aa2c6f1718451d167c13a3186")
  gas: 100000
};
