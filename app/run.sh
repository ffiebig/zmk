#!/bin/bash
set -e
cd /workspaces/zmk/app

# Hardcoded build values
BOARD="nice_nano_v2"
LEFT="corne_left nice_view_adapter nice_view_gem"
RIGHT="corne_right nice_view_adapter nice_view_gem"
BUILD_RESET=false

# Usage function
usage() {
    echo "Usage: $0 [--reset]"
    echo "  --reset    Also build the settings reset UF2"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --reset)
            BUILD_RESET=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

WBUILD="west build -p -d build -b $BOARD -S studio-rpc-usb-uart"

# Build left side
$WBUILD -- -DSHIELD="$LEFT"
echo "Moving left UF2 file to dist directory..."
mv /workspaces/zmk/app/build/zephyr/zmk.uf2 /workspaces/zmk/app/dist/left.uf2

# Build right side
$WBUILD -- -DSHIELD="$RIGHT"
echo "Moving right UF2 file to dist directory..."
mv /workspaces/zmk/app/build/zephyr/zmk.uf2 /workspaces/zmk/app/dist/right.uf2

# Optionally build settings reset
if [ "$BUILD_RESET" = true ]; then
    west build -p -d build -b "$BOARD" -- -DSHIELD="settings_reset"
    echo "Moving settings reset UF2 file to dist directory..."
    mv /workspaces/zmk/app/build/zephyr/zmk.uf2 /workspaces/zmk/app/dist/reset.uf2
fi
