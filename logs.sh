#!/bin/bash
if [ "$1" = "mainnet" ]; then
    docker-compose logs -f libre-mainnet
elif [ "$1" = "testnet" ]; then
    docker-compose logs -f libre-testnet
else
    echo "Usage: ./logs.sh [mainnet|testnet]"
    echo "Or view all logs:"
    docker-compose logs -f
fi
