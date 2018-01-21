module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // Match any network id
      from: "0xC2D7CF95645D33006175B78989035C7c9061d3F9",
      gas: 67000000,
      gasprice: 22
    }
  }
};
