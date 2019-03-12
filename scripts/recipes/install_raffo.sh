#!/bin/bash

# raffo.lv2

. $ZYNTHIAN_RECIPE_DIR/_zynth_lib.sh

cd $ZYNTHIAN_PLUGINS_SRC_DIR

zynth_git https://github.com/nicoroulet/moog.git
if [ ${?} -ne 0 -o  "${build}" = "build" ]; then
	zynth_build_request clear
	cd moog
	if [ "${build}" = "clean" ]
	then
		make clean
	fi
	sed -i -- 's/^INSTALL_DIR.\+$/INSTALL_DIR = ${ZYNTHIAN_PLUGINS_DIR}\/lv2/' Makefile
	sed -i -- 's/-m64//' Makefile
	make -j 4
	make install
	zynth_build_request ready 
	make clean
	cd ..
fi
