#!/bin/bash
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}/..
sudo apt-get install --yes libssl-dev
git clone https://gitlab.kitware.com/cmake/cmake.git
cd cmake
./bootstrap --prefix=/usr/local
make -j4
make install
make clean
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}
