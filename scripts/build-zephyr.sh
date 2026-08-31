#!/bin/bash
# Build script for STM32H723ZG (Zephyr)
# Usage: ./scripts/build-zephyr.sh [debug|release]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

BUILD_TYPE="${1:-release}"
BUILD_DIR="$PROJECT_ROOT/build-fprime-automatic-zephyr"

echo "=========================================="
echo "Building for STM32H723ZG (Zephyr)"
echo "Build type: $BUILD_TYPE"
echo "=========================================="

cd "$PROJECT_ROOT"

if [ "$BUILD_TYPE" = "debug" ]; then
    echo "Configuring debug build..."
    cmake --preset=fprime-zephyr-debug
    echo "Building..."
    cmake --build --preset=fprime-zephyr-debug
else
    echo "Configuring release build..."
    cmake --preset=fprime-zephyr
    echo "Building..."
    cmake --build --preset=fprime-zephyr
fi

echo ""
echo "=========================================="
echo "Build complete!"
echo "Binary location: $BUILD_DIR/zephyr/zephyr.bin"
echo "=========================================="
