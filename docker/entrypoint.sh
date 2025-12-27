#!/bin/sh
set -e

echo "Waiting for blockchain RPC..."
until nc -z blockchain 8545; do
  sleep 1
done

echo "Blockchain RPC ready"

npx hardhat run scripts/deploy.js --network localhost

tail -f /dev/null
