#!/bin/bash

# Install noVNC web viewer

# Get source code
cd $ZYNTHIAN_SW_DIR
if [ -d "noVNC" ]; then
	rm -rf "noVNC"
fi

git clone https://github.com/novnc/noVNC.git
cd ./noVNC/utils
git clone https://github.com/novnc/websockify

# Create novnc launcher
if [ ! -f "$ZYNTHIAN_SW_DIR/noVNC/utils/novnc_proxy" ]; then
	ln -s "$ZYNTHIAN_SW_DIR/noVNC/utils/launch.sh" "$ZYNTHIAN_SW_DIR/noVNC/utils/novnc_proxy"
fi
