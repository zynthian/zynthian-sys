#!/bin/bash

# Install X42 testsignal plugin

# Get source code
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone git://github.com/x42/testsignal.lv2.git

# Build
cd testsignal.lv2
make -j 4
make install PREFIX=/usr/local
make clean

# Create symlinks in zynthian plugins dir
LV2_LOCAL_DIR=/usr/local/lib/lv2
PLUGINS=( testsignal )

for u in "${PLUGINS[@]}"; do
	#Remove pre-existing plugin
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/$u.lv2
	#Create symlinks to LV2
	ln -s $LV2_LOCAL_DIR/$u.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
done
