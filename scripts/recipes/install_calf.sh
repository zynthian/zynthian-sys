#!/bin/bash

# Calf plugins

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "calf" ]; then
	rm -rf "calf"
fi

git clone https://github.com/calf-studio-gear/calf.git
cd calf
./autogen.sh
make -j 4 2>/dev/null
make install
make clean

# Prevent mod-lv2-data from disabling most calf plugins by overwriting manifest.ttl
# with the few calf plugins that have mod-ui interfaces
ln -s /usr/local/lib/lv2/calf.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2/calf_zynth

cd ..
rm -rf "calf"
