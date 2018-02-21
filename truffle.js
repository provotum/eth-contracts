module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id,
      gas: 4300000,
      gasPrice: 22000000000
    }
  }
};
