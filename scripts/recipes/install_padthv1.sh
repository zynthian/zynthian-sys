#!/bin/bash

# padthv1.lv2

. $ZYNTHIAN_RECIPE_DIR/_zynth_lib.sh

cd $ZYNTHIAN_SW_DIR/plugins

zynth_git https://github.com/rncbc/padthv1.git
if [ "${?}" -ne 0 -o "x${build}" != "x" ]
then
	zynth_build_request clear
	cd padthv1
	libtoolize --force
	aclocal
	autoheader
	automake --force-missing --add-missing
	autoconf 
	./configure
	if [ "${build}" = "clean" ]
	then
		make clean
	fi
	make -j 4
	make install
	zynth_build_request ready 
	make clean
	cd ..
fi
