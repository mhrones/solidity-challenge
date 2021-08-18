const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic = "number junk six forget sea jazz acquire verify upper mouse pig famous"

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    develop: {
      port: 8545
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://kovan.infura.io/v3/bce6e7d8e18c470db8a42cc91653c3de")
      },
      network_id: 42
    },
    ropsten: {
      provider: function () {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/bce6e7d8e18c470db8a42cc91653c3de")
      },
      network_id: 3
    }
  },
  compilers: {
    solc: {
      version: "0.6.12",
    },
  }
}
