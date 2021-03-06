var MyToken = artifacts.require("./MyToken.sol");
var MyCrowdSale = artifacts.require("./MyCrowdSale.sol");
var KycContract = artifacts.require("./KycContract.sol");
const dotenv = require("dotenv").config({ path: "../.env" });

module.exports = async function (deployer) {
  const tokenCount = process.env.INITIAL_TOKENS;
  const address = await web3.eth.getAccounts();
  await deployer.deploy(
    MyToken,
    tokenCount,
    "MoonDuck Cappuccino Token",
    "MCT"
  );
  await deployer.deploy(KycContract);
  await deployer.deploy(
    MyCrowdSale,
    1,
    address[0],
    MyToken.address,
    KycContract.address
  );
  const instance = await MyToken.deployed();
  instance.transfer(MyCrowdSale.address, tokenCount);
};
