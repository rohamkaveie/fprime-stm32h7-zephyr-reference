#!/bin/bash
# Deploy script for Raspberry Pi Zero W 2 (Linux)
# Usage: ./scripts/deploy-linux.sh [hostname] [username]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/build-fprime-automatic-linux-rpi"

RPI_HOST="${1:-raspberrypi.local}"
RPI_USER="${2:-pi}"

echo "=========================================="
echo "Deploying to Raspberry Pi Zero W 2"
echo "Host: $RPI_HOST"
echo "User: $RPI_USER"
echo "=========================================="

# Check if binary exists
BINARY_NAME="fprime-rpi-zero-w2-linux"
if [ ! -f "$BUILD_DIR/bin/$BINARY_NAME" ]; then
    echo "Error: Binary not found at $BUILD_DIR/bin/$BINARY_NAME"
    echo "Please build first using: ./scripts/build-linux.sh"
    exit 1
fi

echo "Copying binary to Raspberry Pi..."
scp "$BUILD_DIR/bin/$BINARY_NAME" "$RPI_USER@$RPI_HOST:/home/$RPI_USER/"

echo ""
echo "=========================================="
echo "Deployment complete!"
echo "To run on Raspberry Pi:"
echo "  ssh $RPI_USER@$RPI_HOST"
echo "  ./$BINARY_NAME"
echo "=========================================="
