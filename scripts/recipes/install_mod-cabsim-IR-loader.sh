#!/bin/bash

set -x

# cabsim-IR-loader.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "mod-cabsim-IR-loader" ]; then
	rm -rf "mod-cabsim-IR-loader"
fi

git clone https://github.com/moddevices/mod-cabsim-IR-loader.git
cd mod-cabsim-IR-loader/source
make
cp -r *.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2/
