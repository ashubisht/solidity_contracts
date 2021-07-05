const MyToken = artifacts.require("./MyToken.sol");

const chai = require("./setup.js");
const BN = web3.utils.BN;
const expect = chai.expect;

// Eventually library is crrating problem
contract("MyToken", async (accounts) => {
  // Before Each will disconnect it from main migrations
  beforeEach(async () => {
    this.myToken = await MyToken.new(
      process.env.INITIAL_TOKENS,
      "MoonDuck Cappuccino Token",
      "MCT"
    );
  });

  it("... test that all tokens should be in my account.", async () => {
    let instance = await this.myToken;
    let totalSupply = await instance.totalSupply();
    // const balance = await instance.balanceOf(accounts[0]);
    // assert.equal(balance.valueOf(), totalSupply.valueOf(), "The balance is not same");
    expect(await instance.balanceOf(accounts[0])).to.be.a.bignumber.equal(
      totalSupply
    );
  });

  it("is possible to send token between accounts", async () => {
    const tokenToSend = 1;
    let instance = await this.myToken;
    let totalSupply = await instance.totalSupply();

    expect(await instance.balanceOf(accounts[0])).to.be.a.bignumber.equal(
      totalSupply
    );
    // Is there alternatiove to confirm that statement runs without eventually
    // expect(await instance.transfer(accounts[1], tokenToSend)).to.be.fulfilled;
    await instance.transfer(accounts[1], tokenToSend);
    expect(await instance.balanceOf(accounts[0])).to.be.a.bignumber.equal(
      totalSupply.sub(new BN(tokenToSend))
    );
    expect(await instance.balanceOf(accounts[1])).to.be.a.bignumber.equal(
      new BN(tokenToSend)
    );
  });

  // Why this test fails?
  it("its not possible to send more than maximum possible tokens", async () => {
    let instance = await this.myToken; // Why this is showing error
    const balance = await instance.balanceOf(accounts[0]);
    expect(instance.transfer(accounts[1], balance.add(new BN(1)))).to.eventually
      .be.rejected; // Has to use evenutally for rejection. So kept this test at last
    expect(await instance.balanceOf(accounts[0])).to.be.a.bignumber.equal(
      balance
    );
  });
});
