const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");
require("dotenv").config({ path: "./.env" });

// HDWallet provider needs 2 things (min 1 thing, but 2 are better)
const mnemonic = process.env.MNEMONIC;
const accountIndex = 0;

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    develop: {
      port: 8545,
    },
    ganache_local: {
      provider: function () {
        return new HDWalletProvider(
          mnemonic,
          "http://127.0.0.1:7545",
          accountIndex
        );
      },
      network_id: 5777,
    },
  },
  compilers: {
    solc: {
      version: "0.8.3", // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {
        // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: false,
          runs: 200,
        },
        //  evmVersion: "byzantium"
      },
    },
  },
};
