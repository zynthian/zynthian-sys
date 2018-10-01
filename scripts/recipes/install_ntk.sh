#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ ! -d "ntk" ]; then
	git clone git://git.tuxfamily.org/gitroot/non/fltk.git ntk
	cd ntk
	./waf configure
	./waf
	./waf install
	cd ..
fi
