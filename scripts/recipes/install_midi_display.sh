#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "midi-display.lv2" ]; then
	rm -rf "midi-display.lv2"
fi
git clone https://github.com/vallsv/midi-display.lv2.git
cd midi-display.lv2
make -j 3
DESTDIR=$ZYNTHIAN_PLUGINS_DIR PREFIX=/lv2 SYSPATH="" make install
make clean
cd ..
