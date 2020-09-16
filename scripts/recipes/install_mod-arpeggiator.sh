#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "mod-arpeggiator-lv2" ]; then
	rm -rf "mod-arpeggiator-lv2"
fi

git clone https://github.com/moddevices/mod-arpeggiator-lv2.git
cd mod-arpeggiator-lv2
sed -i 's#^PREFIX  := /usr#PREFIX  := #' Makefile
sed -i 's#^LIBDIR  := $(PREFIX)/lib#LIBDIR  := #' Makefile
sed -i "s#^DESTDIR :=#DESTDIR := $ZYNTHIAN_PLUGINS_DIR#" Makefile
make -j3
make install
cd ..

rm -rf "mod-arpeggiator-lv2"
