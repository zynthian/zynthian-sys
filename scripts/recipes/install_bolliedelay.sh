#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "bolliedelay.lv2" ]; then
	rm -rf "bolliedelay.lv2"
fi

git clone https://github.com/MrBollie/bolliedelay.lv2
cd bolliedelay.lv2
make
make install

rm -rf "bolliedelay.lv2"
