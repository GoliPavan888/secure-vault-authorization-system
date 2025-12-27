require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20",
  networks: {
    docker: {
      url: "http://host.docker.internal:8545"
    }
  }
};
