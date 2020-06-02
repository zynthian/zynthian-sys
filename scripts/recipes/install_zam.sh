#!/bin/bash

# Install ZAM plugins

# Get source code
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "zam-plugins" ]; then
	rm -rf "zam-plugins"
fi

git clone https://github.com/zamaudio/zam-plugins.git
cd zam-plugins
git submodule update --init

# Build
export NOOPT=true
make -j 4
make install
make clean

# Create symlinks in zynthian plugins dir
LV2_LOCAL_DIR=/usr/local/lib/lv2
PLUGINS=( ZamComp ZamCompX2 ZaMultiComp ZamTube ZamEQ2 ZamAutoSat ZamGEQ31 ZaMultiCompX2 ZamGate ZamGateX2 ZamHeadX2 ZaMaximX2 ZamDelay ZamDynamicEQ ZamPhono ZamVerb ZamGrains )

for u in "${PLUGINS[@]}"; do
	#Remove pre-existing plugin
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/$u.lv2
	#Create symlinks to LV2
	ln -s $LV2_LOCAL_DIR/$u.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
done

cd ..
rm -rf "zam-plugins"
