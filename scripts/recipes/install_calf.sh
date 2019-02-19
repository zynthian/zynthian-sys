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

# Prevent mod-lv2-data from disabling most calf plugins by overwriting manifest.ttl
# with the few calf plugins that have mod-ui interfaces
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/calf_zynth.lv2
mv $ZYNTHIAN_PLUGINS_DIR/lv2/calf.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2/calf_zynth.lv2

cd ..
