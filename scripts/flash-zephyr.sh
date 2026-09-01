#!/bin/bash
# Flash script for STM32H723ZG (Zephyr)
# Usage: ./scripts/flash-zephyr.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/build-fprime-automatic-zephyr"

echo "=========================================="
echo "Flashing STM32H723ZG (Zephyr)"
echo "=========================================="

# Check if binary exists
if [ ! -f "$BUILD_DIR/zephyr/zephyr.bin" ]; then
    echo "Error: Binary not found at $BUILD_DIR/zephyr/zephyr.bin"
    echo "Please build first using: ./scripts/build-zephyr.sh"
    exit 1
fi

cd "$PROJECT_ROOT"

ZEPHYR_WORKSPACE="./lib/zephyr-workspace"
export ZEPHYR_BASE="$ZEPHYR_WORKSPACE/zephyr"

echo "Flashing using west..."
west flash --build-dir "$BUILD_DIR"

echo ""
echo "=========================================="
echo "Flash complete!"
echo "=========================================="
