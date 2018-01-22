module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
      from: "0x627306090abaB3A6e1400e9345bC60c78a8BEf57",
      gas: 6700000
    },

    localdev: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      from: "0x2d693f990e7fc837726a67f838b5be96d13f3175",
      gas: 4700000
    }
  }
};
