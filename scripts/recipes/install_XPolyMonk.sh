#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "XPolyMonk.lv2" ]; then
        rm -rf "XPolyMonk.lv2"
fi
apt install -y libcairo2-dev libx11-dev
git clone --recursive https://github.com/brummer10/XPolyMonk.lv2.git
cd XPolyMonk.lv2
make
make install INSTALL_DIR=$ZYNTHIAN_PLUGINS_DIR/lv2
make clean
cd ..
rm -rf "XPolyMonk.lv2"

