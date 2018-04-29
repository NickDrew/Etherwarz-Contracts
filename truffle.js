module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
      from: "0x03D413981e4eF03264D220912d12F6d5E6ced06A",
      gas: 6700000
    },

    localdev: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      from: "0x77a38cd440141392a507a24d24b35e1022477707",
      gas: 4700000
    },

    localdevwork: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3",
      gas: 4700000
    },

    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0x438f65476Dfed23c0621f7A3DC7740F599F59237", // default address to use for any transaction Truffle makes during migrations
      network_id: 4,
      gas: 4612388, // Gas limit used for deploys
      gasPrice: 10000000000
    }
  }
};
