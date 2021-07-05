const MyToken = artifacts.require("./MyToken.sol");
const MyCrowdSale = artifacts.require("./MyCrowdSale.sol");

const chai = require("./setup.js");
const BN = web3.utils.BN;
const expect = chai.expect;

// Eventually library is crrating problem
contract("MyCrowdsale", async (accounts) => {
  // No Before Each as we need migrations file to move tokens to CrowdSaleContract

  it("... should not have any token in deployer account", async () => {
    let instance = await MyToken.deployed();
    expect(await instance.balanceOf(accounts[0])).to.be.a.bignumber.equals(
      new BN(0)
    );
  });

  it("all tokens should be in crowdsale contract", async () => {
    let tokenInstance = await MyToken.deployed();
    let balanceOfCrowdSale = await tokenInstance.balanceOf(MyCrowdSale.address);
    let totalSupply = await tokenInstance.totalSupply();
    expect(balanceOfCrowdSale).to.be.a.bignumber.equals(totalSupply);
  });

  it("... should be possible to buy tokens from crowdsale contract", async () => {
    let tokenInstance = await MyToken.deployed();
    let crowdSaleInstance = await MyCrowdSale.deployed();

    let balanceofDeployer = await tokenInstance.balanceOf(accounts[0]); // initial balance = 0, as all tokens transferred to crowdsale contract

    // expect(
    //   crowdSaleInstance.sendTransaction({
    //     from: accounts[0],
    //     value: web3.utils.toWei("1", "wei"),
    //   })
    // ).to.be.fulfilled;

    // Send 1 wei (actual wei) to crowdsale contract to get 1 token in return
    await crowdSaleInstance.sendTransaction({
      from: accounts[0],
      value: web3.utils.toWei("1", "wei"),
    }); // Fulfilled has some issue with truffle in finishing async contract

    expect(await tokenInstance.balanceOf(accounts[0])).to.be.a.bignumber.equals(
      balanceofDeployer.add(new BN(1))
    );
  });
});
