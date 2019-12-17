#!/bin/bash


cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/vallsv/setbfree-controller.lv2
cd setbfree-controller.lv2
sed -i -- "s|\$(DESTDIR)\$(PREFIX)/lib/lv2|$ZYNTHIAN_PLUGINS_DIR/lv2|" Makefile
make -j 3
make install
cd ..
