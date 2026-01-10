#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
# sha256:723872217c92ce9f10692caf4e96ddd8791b373ebd6dfb2eb42152a9cb56eda2
wget https://github.com/Spotifyd/spotifyd/releases/download/v0.4.2/spotifyd-linux-aarch64-full.tar.gz

tar xzf spotifyd-linux-aarch64-full.tar.gz
rm spotifyd-linux-aarch64-full.tar.gz

mv spotifyd /usr/local/bin/
chmod +x /usr/local/bin/spotifyd

sudo apt install libssl1.1



