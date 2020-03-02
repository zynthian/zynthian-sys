#!/bin/bash

# raffo.lv2

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "moog" ]; then
	rm -rf "moog"
fi

git clone --recurse https://github.com/nicoroulet/moog.git
cd moog
sed -i -- 's/^INSTALL_DIR.\+$/INSTALL_DIR = ${ZYNTHIAN_PLUGINS_DIR}\/lv2/' Makefile
sed -i -- 's/-m64//' Makefile
make -j 4
make install
make clean
cd ..

rm -rf "moog"
