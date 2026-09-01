#!/bin/bash
# Build script for Raspberry Pi Zero W 2 (Linux)
# Usage: ./scripts/build-linux.sh [debug|release]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

BUILD_TYPE="${1:-release}"
BUILD_DIR="$PROJECT_ROOT/build-fprime-automatic-linux-rpi"

echo "=========================================="
echo "Building for Raspberry Pi Zero W 2 (Linux)"
echo "Build type: $BUILD_TYPE"
echo "=========================================="

cd "$PROJECT_ROOT"

if [ "$BUILD_TYPE" = "debug" ]; then
    PRESET_NAME="fprime-linux-rpi-debug"
else
    PRESET_NAME="fprime-linux-rpi"
fi

echo "Configuring build with preset: $PRESET_NAME..."
cmake --preset="$PRESET_NAME"

echo "Building..."
# Use explicit build directory for CMake < 3.28 compatibility
cmake --build "$BUILD_DIR"

echo ""
echo "=========================================="
echo "Build complete!"
echo "Binary location: $BUILD_DIR/bin/"
echo "=========================================="
