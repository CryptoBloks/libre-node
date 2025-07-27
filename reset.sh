#!/bin/bash
echo "Resetting Libre Blockchain nodes..."
docker-compose down -v
rm -rf mainnet/data/* testnet/data/*
echo "Nodes reset complete. Run ./start.sh to restart."
