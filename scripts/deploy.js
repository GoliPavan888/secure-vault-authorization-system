const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Network:", hre.network.name);
  console.log("Deployer:", deployer.address);

  const AuthManager = await hre.ethers.getContractFactory("AuthorizationManager");
  const authManager = await AuthManager.deploy();
  await authManager.waitForDeployment();

  const authManagerAddress = await authManager.getAddress();

  const Vault = await hre.ethers.getContractFactory("SecureVault");
  const vault = await Vault.deploy(authManagerAddress);
  await vault.waitForDeployment();

  console.log("AuthorizationManager:", authManagerAddress);
  console.log("SecureVault:", await vault.getAddress());
  console.log("Chain ID:", (await hre.ethers.provider.getNetwork()).chainId.toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
