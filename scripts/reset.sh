#!/bin/bash
echo "Resetting Libre Blockchain nodes..."
cd "$(dirname "$0")/.."
docker-compose down -v
rm -rf mainnet/data/* testnet/data/*
echo "Nodes reset complete. Run ./scripts/start.sh to restart."
