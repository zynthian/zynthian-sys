#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "darc.lv2" ]; then
	rm -rf "darc.lv2"
fi

export OPTIMIZATIONS=""

git clone git://github.com/x42/darc.lv2.git
cd darc.lv2
make submodules
make
make install PREFIX=/usr/local
ln -s /usr/local/lib/lv2/darc.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
cd ..

rm -rf "darc.lv2"
