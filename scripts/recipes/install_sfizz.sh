#!/bin/bash
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}
sudo apt-get install libxcb-util0-dev libxcb-keysyms1-dev libxcb-xkb-dev libxkbcommon-x11-dev
git clone https://github.com/sfztools/sfizz.git sfizz.lv2
cd sfizz.lv2
mkdir build
cd build
git submodule update --init --recursive
cmake ..
make -j4
make install
mv /usr/local/lib/lv2/sfizz.lv2 ${ZYNTHIAN_PLUGINS_DIR}/lv2/
make clean
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}
