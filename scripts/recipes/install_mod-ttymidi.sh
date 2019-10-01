#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ ! -d "mod-ttymidi" ]; then
	git clone https://github.com/moddevices/mod-ttymidi.git
	cd mod-ttymidi
	# Due to a compatibility problem with certain devices,
	# we use an older version, prior to the rewrote for
	# supporting 1-byte system messages. This should be
	# changed when the problem get solved.
	#git checkout 028ce4e537c7c1a6c237f90c3747cf1794d2d843
	make -j 4
	make install
	cd ..
fi
