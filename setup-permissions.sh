#!/bin/bash

# Libre Blockchain Node Permission Setup Script
# This script ensures proper permissions for Docker volume mounts

set -e

echo "Setting up permissions for Libre blockchain node directories..."

# Get the UID and GID of the eosio user in the container
# We'll use a standard UID/GID that matches what we create in the Dockerfile
EOSIO_UID=1000
EOSIO_GID=1000

# Create directories if they don't exist
mkdir -p mainnet/data/state
mkdir -p mainnet/data/state-history
mkdir -p mainnet/config/protocol_features
mkdir -p testnet/data/state
mkdir -p testnet/data/state-history
mkdir -p testnet/config/protocol_features

# Set ownership to match the eosio user in the container
echo "Setting ownership for mainnet directories..."
sudo chown -R $EOSIO_UID:$EOSIO_GID mainnet/

echo "Setting ownership for testnet directories..."
sudo chown -R $EOSIO_UID:$EOSIO_GID testnet/

# Set proper permissions
echo "Setting permissions..."
sudo chmod -R 755 mainnet/
sudo chmod -R 755 testnet/

echo "✅ Permissions set successfully!"
echo ""
echo "You can now start the nodes with:"
echo "  ./scripts/start.sh" 