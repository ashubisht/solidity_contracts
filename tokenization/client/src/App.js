import React, { Component } from "react";
import MyTokenContract from "./contracts/MyToken.json";
import MyCrowdSaleContract from "./contracts/MyCrowdSale.json";
import KycContract from "./contracts/KycContract.json";

import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { loaded: false, userTokens: 0 };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();

      // Get the contract instance.
      this.networkId = await this.web3.eth.net.getId();

      this.myTokenInstance = new this.web3.eth.Contract(
        MyTokenContract.abi,
        MyTokenContract.networks[this.networkId] &&
          MyTokenContract.networks[this.networkId].address
      );

      this.myCrowdSaleInstance = new this.web3.eth.Contract(
        MyCrowdSaleContract.abi,
        MyCrowdSaleContract.networks[this.networkId] &&
          MyCrowdSaleContract.networks[this.networkId].address
      );

      this.kycInstance = new this.web3.eth.Contract(
        KycContract.abi,
        KycContract.networks[this.networkId] &&
          KycContract.networks[this.networkId].address
      );

      this.listenToTokenTransfer();

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState(
        {
          loaded: true,
          crowdSaleAddress:
            MyCrowdSaleContract.networks[this.networkId].address,
        },
        this.updateUserTokens
      );
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };

  updateUserTokens = async () => {
    const tokens = await this.myTokenInstance.methods
      .balanceOf(this.accounts[0])
      .call();
    this.setState({ userTokens: tokens });
  };

  listenToTokenTransfer = () => {
    this.myTokenInstance.events
      .Transfer({ to: this.accounts[0] })
      .on("data", this.updateUserTokens);
  };

  handleBuyTokens = async () => {
    await this.myCrowdSaleInstance.methods.buyTokens(this.accounts[0]).send({
      from: this.accounts[0],
      value: this.web3.utils.toWei("1", "wei"),
    });
  };

  handleInputChnage = (event) => {
    const target = event.target;
    const value = target.type === "checkbox" ? target.checked : target.value;
    const name = target.name;
    this.setState({
      [name]: value,
    });
  };
  handleKycWhitelisting = async () => {
    await this.kycInstance.methods
      .setKycCompleted(this.state.kycAddress)
      .send({ from: this.accounts[0] });
    alert("KYC for " + this.state.kycAddress + " is completed");
  };

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Moonduck Capucino Token Sale!</h1>
        <p>Get your tokens today</p>
        <h2>Kyc Whitelisting</h2>
        Address to allow:
        <input
          type="text"
          name="kycAddress"
          value={this.state.kycAddress}
          onChange={this.handleInputChnage}
        />
        <button type="button" onClick={this.handleKycWhitelisting}>
          Add to Whitelist
        </button>
        <h2>Buy Tokens</h2>
        <p>
          If you want to buy tokens send Wei to this address:{" "}
          {this.state.crowdSaleAddress}
        </p>
        <p>You currently have {this.state.userTokens} MCT tokens</p>
        <button type="button" onClick={this.handleBuyTokens}>
          Buy more tokens
        </button>
      </div>
    );
  }
}

export default App;
