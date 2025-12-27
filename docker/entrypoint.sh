#!/bin/sh
set -e

npx hardhat run scripts/deploy.js --network localhost

tail -f /dev/null
