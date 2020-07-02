#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "punk-console.lv2" ]; then
	rm -rf "punk-console.lv2"
fi
git clone https://github.com/switryk/punk-console.lv2.git
cd punk-console.lv2
make
make install
make clean
cd ..
rm -rf "punk-console.lv2"
