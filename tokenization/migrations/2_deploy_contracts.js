var MyToken = artifacts.require("./MyToken.sol");

module.exports = function (deployer) {
  deployer.deploy(MyToken, 10000000, "MoonDuck Cappuccino Token", "MCT");
};
