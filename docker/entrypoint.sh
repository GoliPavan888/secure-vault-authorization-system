#!/bin/sh
set -e

echo "Starting Hardhat node..."
npx hardhat node --hostname 0.0.0.0 &
sleep 5

echo "Deploying contracts..."
npx hardhat run scripts/deploy.js --network localhost

tail -f /dev/null
