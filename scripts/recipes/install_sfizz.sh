#!/bin/bash
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}
sudo apt-get install libxcb-util0-dev libxcb-keysyms1-dev libxcb-xkb-dev libxkbcommon-x11-dev libxkbcommon-x11-dev libxkbcommon0
git clone https://github.com/sfztools/sfizz.git sfizz.lv2
cd sfizz.lv2
mkdir build
cd build
git submodule update --init --recursive
cmake ..
make -j4
make install
make clean
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}
