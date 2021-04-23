#!/bin/bash

# riban LV2 plugins
cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d riban ]; then
	rm -rf riban
fi

git clone --recursive https://github.com/riban-bw/lv2.git riban

cd riban
for dir in */
do
	cd $dir
	sed -i "s#^PREFIX.*=.*#PREFIX := $ZYNTHIAN_PLUGINS_DIR#" Makefile
	sed -i "s#^DESTDIR.*=.*#DESTDIR := /lv2#" Makefile
	make
	make install
	cd -
done