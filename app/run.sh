#!/bin/bash
set -e
cd /workspaces/zmk/app

BOARD="nice_nano_v2"
LEFT="corne_left nice_view_adapter nice_view_gem"
RIGHT="corne_right nice_view_adapter nice_view_gem"
WBUILD="west build -p -d build -b $BOARD -S studio-rpc-usb-uart"

$WBUILD -- -DSHIELD="$LEFT"
echo "Moving left UF2 file to dist directory..."
mv /workspaces/zmk/app/build/zephyr/zmk.uf2 /workspaces/zmk/app/dist/left.uf2

$WBUILD -- -DSHIELD="$RIGHT"
echo "Moving right UF2 file to dist directory..."
mv /workspaces/zmk/app/build/zephyr/zmk.uf2 /workspaces/zmk/app/dist/right.uf2

west build -p -d build -b nice_nano_v2 -- -DSHIELD="settings_reset" 
echo "Moving settings reset UF 2 file to dist directory..."
mv /workspaces/zmk/app/build/zephyr/zmk.uf2 /workspaces/zmk/app/dist/reset.uf2
