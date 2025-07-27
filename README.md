# Libre Blockchain Node Docker Setup

This repository contains a Docker-based setup for running Libre blockchain nodes (mainnet and testnet) using AntelopeIO Leap v5.0.3.

## Overview

Libre is a blockchain platform based on AntelopeIO technology. This setup provides:

- **Libre Mainnet API Node** (Port 9888)
- **Libre Testnet API Node** (Port 9889)
- **State History Plugin (SHiP)** endpoints for both networks
- **P2P connectivity** to official Libre peers

## Prerequisites

- Docker and Docker Compose installed
- At least 8GB RAM available
- 100GB+ free disk space for blockchain data
- Stable internet connection
- Ports 9888, 9889, 9876, 9877, 9080, 9081 available

## Quick Start

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd docker-libre-node
   ```

2. **Set up permissions (required for Docker volume mounts):**

   ```bash
   ./setup-permissions.sh
   ```

3. **Build and start the nodes:**

   ```bash
   ./start.sh
   ```

4. **Check node status:**
   ```bash
   ./status.sh
   ```

## Manual Setup

If you prefer to set up manually:

1. **Build the Docker image:**

   ```bash
   ./build.sh
   ```

2. **Start the nodes:**

   ```bash
   docker-compose up -d
   ```

3. **View logs:**
   ```bash
   ./logs.sh mainnet    # Mainnet logs
   ./logs.sh testnet    # Testnet logs
   ```

## Configuration

### Network Information

| Network | Chain ID                                                           | API Port | P2P Port | SHiP Port |
| ------- | ------------------------------------------------------------------ | -------- | -------- | --------- |
| Mainnet | `38b1d7815474d0bf271d659c50b579893768b3b2c3dc6a14c4be6a7b3e14f2fb` | 9888     | 9876     | 9080      |
| Testnet | `b64646740308df2ee06c6b72f34c0f7fa066d940e831f752db2006fcc2b78dee` | 9889     | 9877     | 9081      |

### P2P Peers

**Mainnet:**

- `p2p.libre.iad.cryptobloks.io:9876`
- `p2p.libre.pdx.cryptobloks.io:9876`

**Testnet:**

- `p2p.testnet.libre.iad.cryptobloks.io:9876`
- `p2p.testnet.libre.pdx.cryptobloks.io:9876`

## API Endpoints

### Mainnet

- **HTTP API:** http://localhost:9888
- **State History:** ws://localhost:9080
- **Node Info:** http://localhost:9888/v1/chain/get_info

### Testnet

- **HTTP API:** http://localhost:9889
- **State History:** ws://localhost:9081
- **Node Info:** http://localhost:9889/v1/chain/get_info

## Management Scripts

| Script       | Description                                 |
| ------------ | ------------------------------------------- |
| `start.sh`   | Start both nodes (builds image if needed)   |
| `stop.sh`    | Stop both nodes                             |
| `restart.sh` | Restart both nodes                          |
| `logs.sh`    | View logs (mainnet\|testnet)                |
| `status.sh`  | Check node status and connectivity          |
| `reset.sh`   | Reset node data (WARNING: deletes all data) |
| `build.sh`   | Build Docker image manually                 |

## Directory Structure

```
docker-libre-node/
├── Dockerfile                 # Custom Libre node image
├── docker-compose.yml         # Docker Compose configuration
├── mainnet/                   # Mainnet configuration
│   ├── config/
│   │   ├── config.ini        # Mainnet node configuration
│   │   └── genesis.json      # Mainnet genesis block
│   ├── data/                 # Mainnet blockchain data
│   └── logs/                 # Mainnet logs
├── testnet/                   # Testnet configuration
│   ├── config/
│   │   ├── config.ini        # Testnet node configuration
│   │   └── genesis.json      # Testnet genesis block
│   ├── data/                 # Testnet blockchain data
│   └── logs/                 # Testnet logs
└── scripts/                   # Management scripts
```

## Configuration Files

### Node Configuration (`config.ini`)

Key configuration options:

- **Chain ID:** Network identifier
- **HTTP Server:** API endpoint configuration
- **P2P Settings:** Peer connectivity
- **Plugin Configuration:** Enabled plugins
- **Performance Tuning:** Resource allocation
- **State History:** Historical data access

### Genesis Files

Contains initial blockchain state:

- **Initial Timestamp:** Genesis block time
- **Initial Key:** Genesis block producer key
- **Initial Configuration:** Network parameters

## Troubleshooting

### Common Issues

1. **Port conflicts:**

   ```bash
   # Check if ports are in use
   netstat -tulpn | grep -E ':(9888|9889|9876|9877|9080|9081)'
   ```

2. **Insufficient memory:**

   ```bash
   # Check available memory
   free -h
   ```

3. **Slow sync:**

   - Ensure stable internet connection
   - Check peer connectivity
   - Monitor system resources

4. **Container won't start:**
   ```bash
   # Check container logs
   docker-compose logs libre-mainnet
   docker-compose logs libre-testnet
   ```

### Reset Node Data

⚠️ **WARNING:** This will delete all blockchain data and require full resync.

```bash
./reset.sh
```

### View Detailed Logs

```bash
# Mainnet logs
./logs.sh mainnet

# Testnet logs
./logs.sh testnet

# All logs
docker-compose logs -f
```

## Performance Tuning

### Resource Allocation

The default configuration is optimized for:

- **4 CPU cores** for chain processing
- **6 HTTP threads** for API requests
- **16GB RAM** for mainnet state
- **8GB RAM** for testnet state

### Customization

Edit `docker-compose.yml` to adjust:

- CPU/memory limits
- Port mappings
- Volume mounts
- Environment variables

## Security Considerations

- **Firewall:** Restrict access to necessary ports only
- **Authentication:** Implement API authentication if exposed publicly
- **Updates:** Regularly update the Docker image for security patches
- **Backups:** Regularly backup configuration and data directories

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:

- Check the troubleshooting section
- Review Libre blockchain documentation
- Open an issue on GitHub

## Changelog

### v1.0.0

- Initial release
- Libre mainnet and testnet support
- AntelopeIO Leap v5.0.3
- State History Plugin support
- Comprehensive management scripts
