#!/bin/bash
# Build script for Raspberry Pi Zero W 2 (Linux)
# Usage: ./scripts/build-linux.sh [debug|release]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

BUILD_TYPE="${1:-release}"

echo "=========================================="
echo "Building for Raspberry Pi Zero W 2 (Linux)"
echo "Build type: $BUILD_TYPE"
echo "=========================================="

cd "$PROJECT_ROOT"

if [ "$BUILD_TYPE" = "debug" ]; then
    echo "Configuring debug build..."
    cmake --preset=fprime-linux-rpi-debug
    echo "Building..."
    cmake --build --preset=fprime-linux-rpi-debug
else
    echo "Configuring release build..."
    cmake --preset=fprime-linux-rpi
    echo "Building..."
    cmake --build --preset=fprime-linux-rpi
fi

echo ""
echo "=========================================="
echo "Build complete!"
echo "Binary location: $PROJECT_ROOT/build-fprime-automatic-linux-rpi/bin/"
echo "=========================================="
