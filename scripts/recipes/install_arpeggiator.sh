#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "arpeggiator_LV2" ]; then
	rm -rf "arpeggiator_LV2"
fi

git clone https://github.com/BramGiesen/arpeggiator_LV2.git
cd arpeggiator_LV2
sed -i 's#^PREFIX  := /usr#PREFIX  := #' Makefile
sed -i 's#^LIBDIR  := $(PREFIX)/lib#LIBDIR  := #' Makefile
sed -i "s#^DESTDIR :=#DESTDIR := $ZYNTHIAN_PLUGINS_DIR#" Makefile
make -j3
make install
cd ..

rm -rf "arpeggiator_LV2"
