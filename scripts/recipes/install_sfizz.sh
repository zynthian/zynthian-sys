#!/bin/bash

cd ${ZYNTHIAN_SW_DIR}

apt-get -y update --allow-releaseinfo-change
apt-get -y install libxcb-util0-dev libxcb-keysyms1-dev libxcb-xkb-dev libxkbcommon-x11-dev zenity

if [ -d "sfizz" ]; then
	rm -rf "sfizz"
fi

#git clone https://github.com/sfztools/sfizz.git sfizz
git clone https://github.com/zynthian/sfizz.git sfizz
cd sfizz
mkdir build
cd build
git submodule update --init --recursive
cmake ..
make -j 4
make install
