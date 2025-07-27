#!/bin/bash
echo "Starting Libre Blockchain nodes..."

# Check if permissions are set up correctly
if [ ! -w "mainnet/data" ] || [ ! -w "testnet/data" ]; then
    echo "⚠️  Warning: Data directories may not have correct permissions."
    echo "   Run '../setup-permissions.sh' if you encounter permission errors."
    echo ""
fi

# Check if Docker image exists, build if not
if ! docker images | grep -q "libre-node.*5.0.3"; then
    echo "Docker image not found. Building..."
    ../build.sh
fi

docker-compose up -d
echo "Waiting for nodes to start..."
sleep 15
echo "Libre nodes status:"
docker-compose ps
echo ""
echo "Libre Mainnet API: http://localhost:9888"
echo "Libre Testnet API: http://localhost:9889"
echo ""
echo "State History Endpoints:"
echo "Libre Mainnet SHiP: ws://localhost:9080"
echo "Libre Testnet SHiP: ws://localhost:9081"
echo ""
echo "To check node info:"
echo "curl http://localhost:9888/v1/chain/get_info  # Mainnet"
echo "curl http://localhost:9889/v1/chain/get_info  # Testnet"
echo ""
echo "Note: Initial sync may take time depending on network connectivity"
