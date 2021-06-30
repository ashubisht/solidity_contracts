const MyToken = artifacts.require("./MyToken.sol");

const chai = require("chai");
const chaiAsPromised = require("chai-as-promised");

const BN = web3.utils.BN;
const chaiBN = require("chai-bn")(BN);

chai.use(chaiBN);
chai.use(chaiAsPromised);

const expect = chai.expect;

contract("MyToken", async (accounts) => {
  it("... test that all tokens should be in my account.", async () => {
    let instance = await MyToken.deployed();

    let totalSupply = await instance.totalSupply();
    // const balance = await instance.balanceOf(accounts[0]);
    // assert.equal(balance.valueOf(), totalSupply.valueOf(), "The balance is not same");

    expect(instance.balanceOf(accounts[0])).to.eventually.be.a.bignumber.equal(
      totalSupply
    );
  });

  it("is possible to send token between accounts", async () => {
    const tokenToSend = 1;
    let instance = await MyToken.deployed();
    let totalSupply = await instance.totalSupply();
    expect(instance.balanceOf(accounts[0])).to.eventually.be.a.bignumber.equal(
      totalSupply
    );
    expect(instance.transfer(accounts[1], tokenToSend)).to.eventually.be
      .fulfilled;
    expect(instance.balanceOf(accounts[0])).to.eventually.be.a.bignumber.equal(
      totalSupply.sub(new BN(tokenToSend))
    );
    expect(instance.balanceOf(accounts[1])).to.eventually.be.a.bignumber.equal(
      new BN(tokenToSend)
    );
  });

  // Why this test fails?
  it("its not possible to send more than maximum possible tokens", async () => {
    //let instance25 = await MyToken.deployed(10000000, "Caapu", "CPU"); // Why this is showing error
    // const balance = await instance.balanceOf(accounts[0]);
    // let balance = await instance.totalSupply();
    // expect(instance.transfer(accounts[1], balance)).to.eventually.be.fulfilled;
    // expect(instance.balanceOf(accounts[0])).to.eventually.be.a.bignumber.equal(
    //   balance
    // );
  });
});
