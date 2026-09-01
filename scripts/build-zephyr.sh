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

# Set up Zephyr environment
if [ -d "$PROJECT_ROOT/fprime-venv" ]; then
    source "$PROJECT_ROOT/fprime-venv/bin/activate"
    echo "Activated virtual environment at $PROJECT_ROOT/fprime-venv"
fi

# Ensure ZEPHYR_BASE is set
if [ -z "$ZEPHYR_BASE" ]; then
    if [ -d "$PROJECT_ROOT/lib/zephyr-workspace/zephyr" ]; then
        export ZEPHYR_BASE="$PROJECT_ROOT/lib/zephyr-workspace/zephyr"
        echo "Set ZEPHYR_BASE=$ZEPHYR_BASE"
    else
        echo "Warning: ZEPHYR_BASE not set and zephyr-workspace not found"
    fi
fi

if [ "$BUILD_TYPE" = "debug" ]; then
    PRESET_NAME="fprime-zephyr-debug"
else
    PRESET_NAME="fprime-zephyr"
fi

echo "Configuring build with preset: $PRESET_NAME..."
cmake --preset="$PRESET_NAME"

echo "Building..."
# Use explicit build directory for CMake < 3.28 compatibility
cmake --build "$BUILD_DIR"

echo ""
echo "=========================================="
echo "Build complete!"
echo "Binary location: $BUILD_DIR/zephyr/zephyr.bin"
echo "=========================================="
