#!/bin/bash

# Node.js multiversion framwork
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# Required libraries
#apt-get install libavformat-dev libswscale-dev libavcodec-dev

# AminoGFX: Accelerated Graphics Library for Node.js
nvm install 7.10.1
nvm use 7.10.1
npm install aminogfx-gl

# CreateJS + EaselJS
# apt-get isntall giflib-tools libgif-dev
nvm use 11.0.0
npm install createjs
npm install node-easel
#npm install canvas

# Install MIDI support
npm install midi
