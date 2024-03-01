#!/bin/bash

# mod-mda.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "mda-lv2" ]; then
	rm -rf "mda-lv2"
fi

git clone https://github.com/moddevices/mda-lv2.git
cd mda-lv2
./waf configure --lv2-user --lv2dir=$ZYNTHIAN_PLUGINS_DIR/lv2
./waf build
./waf -j1 install
./waf clean
cd ..

rm -rf "mda-lv2"