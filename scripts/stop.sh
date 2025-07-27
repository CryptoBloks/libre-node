#!/bin/bash
echo "Stopping Libre Blockchain nodes..."
cd "$(dirname "$0")/.."
docker-compose down
