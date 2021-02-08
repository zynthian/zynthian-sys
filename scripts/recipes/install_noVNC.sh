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
