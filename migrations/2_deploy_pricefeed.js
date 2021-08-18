var PriceFeed = artifacts.require("./PriceFeed.sol");

module.exports = function(deployer) {
  deployer.deploy(PriceFeed);
  gas: 100000
};
