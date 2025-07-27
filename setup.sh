#!/bin/bash

# Libre Blockchain Nodeos Docker Setup Script
# This script sets up 2 nodeos servers as Docker containers
# Node 1: Libre Mainnet API Node
# Node 2: Libre Testnet API Node

set -e

echo "Setting up Libre Blockchain Nodeos Docker environment..."

# Create directory structure
mkdir -p libre-nodes/{mainnet,testnet}/{config,data,logs}
cd libre-nodes

echo "Creating Docker Compose configuration..."

# Create Docker Compose file
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  libre-mainnet:
    image: eosio/leap:v5.0.3
    container_name: libre-mainnet-api
    command: >
      nodeos
      --config-dir /opt/eosio/config
      --data-dir /opt/eosio/data
      --http-server-address=0.0.0.0:9888
      --p2p-listen-endpoint=0.0.0.0:9876
      --p2p-peer-address=p2p.libre.iad.cryptobloks.io:9876
      --p2p-peer-address=p2p.libre.pdx.cryptobloks.io:9876
      --state-history-endpoint=0.0.0.0:9080
      --contracts-console
      --verbose-http-errors
      --max-transaction-time=1000
      --abi-serializer-max-time-ms=2000
      --chain-threads=4
      --http-threads=6
    ports:
      - "9888:9888"
      - "9876:9876"
      - "9080:9080"
    volumes:
      - ./mainnet/config:/opt/eosio/config
      - ./mainnet/data:/opt/eosio/data
      - ./mainnet/logs:/opt/eosio/logs
    networks:
      - libre-network
    restart: unless-stopped

  libre-testnet:
    image: eosio/leap:v5.0.3
    container_name: libre-testnet-api
    command: >
      nodeos
      --config-dir /opt/eosio/config
      --data-dir /opt/eosio/data
      --http-server-address=0.0.0.0:9889
      --p2p-listen-endpoint=0.0.0.0:9877
      --p2p-peer-address=p2p.testnet.libre.iad.cryptobloks.io:9876
      --p2p-peer-address=p2p.testnet.libre.pdx.cryptobloks.io:9876
      --state-history-endpoint=0.0.0.0:9081
      --contracts-console
      --verbose-http-errors
      --max-transaction-time=1000
      --abi-serializer-max-time-ms=2000
      --chain-threads=4
      --http-threads=6
    ports:
      - "9889:9889"
      - "9877:9877"
      - "9081:9081"
    volumes:
      - ./testnet/config:/opt/eosio/config
      - ./testnet/data:/opt/eosio/data
      - ./testnet/logs:/opt/eosio/logs
    networks:
      - libre-network
    restart: unless-stopped

networks:
  libre-network:
    driver: bridge
EOF

echo "Creating Libre Mainnet configuration..."

# Create configuration for Libre Mainnet API Node
cat > mainnet/config/config.ini << 'EOF'
# Libre Mainnet API Node Configuration

# Chain Configuration
chain-id = 38b1d7815474d0bf271d659c50b579893768b3b2c3dc6a14c4be6a7b3e14f2fb

# HTTP and P2P Configuration
http-server-address = 0.0.0.0:9888
p2p-listen-endpoint = 0.0.0.0:9876

# Libre Mainnet P2P Peers
p2p-peer-address = p2p.libre.iad.cryptobloks.io:9876
p2p-peer-address = p2p.libre.pdx.cryptobloks.io:9876

# Plugin Configuration
plugin = eosio::chain_plugin
plugin = eosio::chain_api_plugin
plugin = eosio::http_plugin
plugin = eosio::net_plugin
plugin = eosio::state_history_plugin

# State History Configuration
state-history-endpoint = 0.0.0.0:9080
trace-history = true
chain-state-history = true
state-history-dir = /opt/eosio/data/state-history

# Chain Configuration
chain-state-db-size-mb = 16384
reversible-blocks-db-size-mb = 2048
max-irreversible-block-age = -1

# Logging Configuration
contracts-console = true
verbose-http-errors = true

# Performance Settings
max-transaction-time = 1000
abi-serializer-max-time-ms = 2000
wasm-runtime = eos-vm-jit
chain-threads = 4
http-threads = 6

# P2P Configuration
max-clients = 200
connection-cleanup-period = 30
net-threads = 4
p2p-max-nodes-per-host = 10
agent-name = "Libre API Node"

# Access Control
access-control-allow-origin = *
access-control-allow-headers = *
http-validate-host = false

# Resource Limits
http-max-response-time-ms = 100
http-max-bytes-in-flight-mb = 500
EOF

echo "Creating Libre Testnet configuration..."

# Create configuration for Libre Testnet API Node
cat > testnet/config/config.ini << 'EOF'
# Libre Testnet API Node Configuration

# Chain Configuration
chain-id = b64646740308df2ee06c6b72f34c0f7fa066d940e831f752db2006fcc2b78dee

# HTTP and P2P Configuration
http-server-address = 0.0.0.0:9889
p2p-listen-endpoint = 0.0.0.0:9877

# Libre Testnet P2P Peers
p2p-peer-address = p2p.testnet.libre.iad.cryptobloks.io:9876
p2p-peer-address = p2p.testnet.libre.pdx.cryptobloks.io:9876

# Plugin Configuration
plugin = eosio::chain_plugin
plugin = eosio::chain_api_plugin
plugin = eosio::http_plugin
plugin = eosio::net_plugin
plugin = eosio::state_history_plugin

# State History Configuration
state-history-endpoint = 0.0.0.0:9081
trace-history = true
chain-state-history = true
state-history-dir = /opt/eosio/data/state-history

# Chain Configuration
chain-state-db-size-mb = 8192
reversible-blocks-db-size-mb = 1024
max-irreversible-block-age = -1

# Logging Configuration
contracts-console = true
verbose-http-errors = true

# Performance Settings
max-transaction-time = 1000
abi-serializer-max-time-ms = 2000
wasm-runtime = eos-vm-jit
chain-threads = 4
http-threads = 6

# P2P Configuration
max-clients = 150
connection-cleanup-period = 30
net-threads = 4
p2p-max-nodes-per-host = 10
agent-name = "Libre Testnet API Node"

# Access Control
access-control-allow-origin = *
access-control-allow-headers = *
http-validate-host = false

# Resource Limits
http-max-response-time-ms = 100
http-max-bytes-in-flight-mb = 500
EOF

echo "Creating genesis files..."

# Create genesis.json for Libre Mainnet
cat > mainnet/config/genesis.json << 'EOF'
{
    "initial_timestamp": "2022-07-04T17:44:00.000",
    "initial_key": "EOS5CFq1Bd8HZV8zfDV5tKeRBJ1ibrebQibUgRgFXVeC45K6MSF4q",
    "initial_configuration": {
      "max_block_net_usage": 1048576,
      "target_block_net_usage_pct": 1000,
      "max_transaction_net_usage": 524288,
      "base_per_transaction_net_usage": 12,
      "net_usage_leeway": 500,
      "context_free_discount_net_usage_num": 20,
      "context_free_discount_net_usage_den": 100,
      "max_block_cpu_usage": 100000,
      "target_block_cpu_usage_pct": 500,
      "max_transaction_cpu_usage": 50000,
      "min_transaction_cpu_usage": 100,
      "max_transaction_lifetime": 3600,
      "deferred_trx_expiration_window": 600,
      "max_transaction_delay": 3888000,
      "max_inline_action_size": 524287,
      "max_inline_action_depth": 10,
      "max_authority_depth": 10
    }
}
EOF

# Create genesis.json for Libre Testnet
cat > testnet/config/genesis.json << 'EOF'
{
  "initial_timestamp": "2022-07-13T12:20:00.000",
  "initial_key": "EOS7dNVunVzniVwyag9t6ci9a2DyegqNowsYohjiVUihEjChMBDVP",
  "initial_configuration": {
    "max_block_net_usage": 1048576,
    "target_block_net_usage_pct": 1000,
    "max_transaction_net_usage": 524288,
    "base_per_transaction_net_usage": 12,
    "net_usage_leeway": 500,
    "context_free_discount_net_usage_num": 20,
    "context_free_discount_net_usage_den": 100,
    "max_block_cpu_usage": 100000,
    "target_block_cpu_usage_pct": 500,
    "max_transaction_cpu_usage": 50000,
    "min_transaction_cpu_usage": 100,
    "max_transaction_lifetime": 3600,
    "deferred_trx_expiration_window": 600,
    "max_transaction_delay": 3888000,
    "max_inline_action_size": 524287,
    "max_inline_action_depth": 10,
    "max_authority_depth": 10
  }
}
EOF

echo "Creating helper scripts..."

# Create helper scripts
cat > start.sh << 'EOF'
#!/bin/bash
echo "Starting Libre Blockchain nodes..."
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
EOF

cat > stop.sh << 'EOF'
#!/bin/bash
echo "Stopping Libre Blockchain nodes..."
docker-compose down
EOF

cat > logs.sh << 'EOF'
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
EOF

cat > reset.sh << 'EOF'
#!/bin/bash
echo "Resetting Libre Blockchain nodes..."
docker-compose down -v
rm -rf mainnet/data/* testnet/data/*
echo "Nodes reset complete. Run ./start.sh to restart."
EOF

cat > status.sh << 'EOF'
#!/bin/bash
echo "=== Libre Blockchain Nodes Status ==="
echo ""
echo "Docker containers:"
docker-compose ps
echo ""
echo "Libre Mainnet Info:"
curl -s http://localhost:9888/v1/chain/get_info | jq '.' 2>/dev/null || echo "Mainnet node not responding"
echo ""
echo "Libre Testnet Info:"
curl -s http://localhost:9889/v1/chain/get_info | jq '.' 2>/dev/null || echo "Testnet node not responding"
echo ""
echo "P2P Connection Status:"
echo "Mainnet peers:"
curl -s http://localhost:9888/v1/net/connections | jq '.[].peer' 2>/dev/null || echo "Cannot fetch mainnet peers"
echo ""
echo "Testnet peers:"
curl -s http://localhost:9889/v1/net/connections | jq '.[].peer' 2>/dev/null || echo "Cannot fetch testnet peers"
EOF

# Make scripts executable
chmod +x *.sh

echo "✅ Setup complete!"
echo ""
echo "Libre Blockchain Nodeos Docker setup complete!"
echo ""
echo "Using EOSIO Leap v5.0.3"
echo ""
echo "Directory structure created:"
echo "├── docker-compose.yml"
echo "├── mainnet/"
echo "│   ├── config/"
echo "│   ├── data/"
echo "│   └── logs/"
echo "├── testnet/"
echo "│   ├── config/"
echo "│   ├── data/"
echo "│   └── logs/"
echo "└── Helper scripts:"
echo "    ├── start.sh    - Start the nodes"
echo "    ├── stop.sh     - Stop the nodes"
echo "    ├── logs.sh     - View logs (mainnet|testnet)"
echo "    ├── reset.sh    - Reset node data"
echo "    └── status.sh   - Check node status"
echo ""
echo "To start the nodes:"
echo "  ./start.sh"
echo ""
echo "Libre Mainnet API: http://localhost:9888"
echo "Libre Testnet API: http://localhost:9889"
echo ""
echo "State History (SHiP) Endpoints:"
echo "Libre Mainnet SHiP: ws://localhost:9080"
echo "Libre Testnet SHiP: ws://localhost:9081"
echo ""
echo "Chain IDs:"
echo "  Mainnet: 38b1d7815474d0bf271d659c50b579893768b3b2c3dc6a14c4be6a7b3e14f2fb"
echo "  Testnet: b64646740308df2ee06c6b72f34c0f7fa066d940e831f752db2006fcc2b78dee"
echo ""
echo "P2P Peers:"
echo "  Mainnet: p2p.libre.iad.cryptobloks.io:9876, p2p.libre.pdx.cryptobloks.io:9876"
echo "  Testnet: p2p.testnet.libre.iad.cryptobloks.io:9876, p2p.testnet.libre.pdx.cryptobloks.io:9876"
echo ""
echo "Requirements:"
echo "- Docker and Docker Compose installed"
echo "- Ports 9888, 9889, 9876, 9877, 9080, 9081 available"
echo "- At least 8GB RAM recommended for initial sync"
echo "- Stable internet connection for blockchain sync"
echo "- Additional storage for state history data"