#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/vallsv/midi-display.lv2.git
cd midi-display.lv2
make -j 3
DESTDIR=/zynthian/zynthian-plugins PREFIX=/lv2 SYSPATH="" make install
cd ..
