#!/bin/bash

# Calf plugins

cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/calf-studio-gear/calf.git
cd calf
./autogen.sh
./configure --with-lv2-dir=$ZYNTHIAN_PLUGINS_DIR/lv2
make -j 4
make install
make clean
cd ..
