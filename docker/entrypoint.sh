#!/bin/sh
set -e

echo "Waiting for blockchain startup..."
sleep 5

npx hardhat run scripts/deploy.js --network docker

tail -f /dev/null
