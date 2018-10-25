#!/bin/bash

# Calf plugins

cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/calf-studio-gear/calf.git
cd calf
git checkout 0.90.1
./autogen.sh
./configure --with-lv2-dir=$ZYNTHIAN_PLUGINS_DIR/lv2
make -j 4
make install
make clean
cd ..
