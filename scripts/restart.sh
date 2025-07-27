#!/bin/bash

echo "Restarting Libre Blockchain nodes..."
cd "$(dirname "$0")/.."
docker-compose restart
echo "Waiting for nodes to restart..."
sleep 10
echo "Libre nodes status:"
docker-compose ps
echo ""
echo "Libre Mainnet API: http://localhost:9888"
echo "Libre Testnet API: http://localhost:9889" 