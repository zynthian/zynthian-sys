#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ ! -d "jpmidi" ]; then
	git clone https://github.com/jerash/jpmidi.git
	./configure
	make -j 4
	cd ../..
fi

