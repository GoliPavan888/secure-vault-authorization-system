#!/bin/sh
set -e

echo "Waiting for blockchain startup..."
sleep 6

npx hardhat run scripts/deploy.js --network docker

tail -f /dev/null
