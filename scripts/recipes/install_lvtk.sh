#!/bin/bash

# LVtk
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/lvtk/lvtk.git
cd lvtk
git checkout 1.x
./waf configure --disable-ui
./waf build
sudo ./waf install
./waf clean
cd ..
apt-get install -y lvtk-tools
cp /usr/local/lib/pkgconfig/lvtk-plugin-1.pc /usr/local/lib/pkgconfig/lvtk-plugin-2.pc
