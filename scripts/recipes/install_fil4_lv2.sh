#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "fil4.lv2" ]; then
	rm -rf "fil4.lv2"
fi

export OPTIMIZATIONS=""

git clone git://github.com/x42/fil4.lv2.git
cd fil4.lv2
make submodules
make
make install PREFIX=/usr/local
ln -s /usr/local/lib/lv2/fil4.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
cd ..

rm -rf "fil4.lv2"
