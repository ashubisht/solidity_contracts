const UBCToken = artifacts.require("./UBCToken.sol");

module.exports = function (deployer) {
  deployer.deploy(UBCToken, "UtkasrhCoin", "UBC", 1000000000, 8);
};
