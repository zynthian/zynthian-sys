#!/bin/bash

# Calf plugins

cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/calf-studio-gear/calf.git
cd calf
./autogen.sh
make -j 4
make install
make clean

ln -s /usr/local/lib/lv2/calf.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

# Prevent mod-lv2-data from disabling most calf plugins by overwriting manifest.ttl
# with the few calf plugins that have mod-ui interfaces
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/calf_zynth.lv2
mv $ZYNTHIAN_PLUGINS_DIR/lv2/calf.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2/calf_zynth.lv2

cd ..
