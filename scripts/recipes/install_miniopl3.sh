#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "miniopl3" ]; then
	rm -rf "miniopl3"
fi
git clone --recursive https://github.com/jpcima/miniopl3.git
cd miniopl3
sed -i -- 's/\-mtune\=generic//' ./dpf/Makefile.base.mk
make -j 3
make install
make clean
cd ..
rm -rf "miniopl3"

ln -s /usr/local/lib/lv2/miniopl3.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/miniopl3-presets.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
