# secure-vault-authorization-system

# Secure Vault Authorization System

## Objective
This project demonstrates a secure multi-contract design for controlled asset withdrawals.  
Fund custody and authorization validation are intentionally separated into two on-chain contracts to ensure clear trust boundaries and enforce one-time, deterministic permissions.

---

## System Architecture
- **SecureVault**  
  Holds native currency deposits and executes withdrawals only after authorization approval.

- **AuthorizationManager**  
  Validates off-chain generated withdrawal permissions and guarantees each authorization is consumed exactly once.

The vault never performs cryptographic verification itself and relies entirely on the authorization manager.

---

## Prerequisites
- Docker
- Docker Compose

---

## Run the System

```bash
docker-compose up --build

This will:

Start a local EVM node

Compile all smart contracts

Deploy AuthorizationManager

Deploy SecureVault with the authorization manager address

Print deployment details to logs


Deployment Information

From the deployer container logs, note:

AuthorizationManager address

SecureVault address

Chain ID

Manual Validation Flow
Step 1: Open Hardhat Console

npx hardhat console --network localhost

Step 2: Deposit ETH into the Vault
const vault = await ethers.getContractAt("SecureVault", "<VAULT_ADDRESS>");
await vault.sendTransaction({ value: ethers.parseEther("5") });

Step 3: Generate Withdrawal Authorization (Off-Chain)
const signer = (await ethers.getSigners())[0];

const authId = ethers.keccak256(ethers.randomBytes(32));
const recipient = "<RECIPIENT_ADDRESS>";
const amount = ethers.parseEther("1");

const chainId = (await ethers.provider.getNetwork()).chainId;

const message = ethers.solidityPackedKeccak256(
  ["address","address","uint256","uint256","bytes32"],
  [vault.target, recipient, amount, chainId, authId]
);

const signature = await signer.signMessage(ethers.getBytes(message));

Step 4: Execute Authorized Withdrawal
await vault.withdraw(recipient, amount, authId, signature);

Step 5: Attempt Authorization Reuse (Must Revert)
await vault.withdraw(recipient, amount, authId, signature);
The transaction will revert because the authorization has already been consumed.

Invariants Enforced

Vault balance never becomes negative

Each authorization results in exactly one state transition

Authorizations are tightly bound to:

Vault instance

Network (chain ID)

Recipient

Withdrawal amount

Authorization reuse is impossible

Unauthorized callers cannot trigger withdrawals

All critical actions emit observable events

Notes

No frontend is required

All evaluation is performed locally using Docker

The system behaves deterministically under repeated or unexpected call patterns