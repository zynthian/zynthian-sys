#!/bin/bash

#apt-get install libgtk2.0-dev libgtk-3-dev liblilv-dev lv2-dev libx11-dev make pkg-config

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "lv2-gtk-ui-bridge" ]; then
	rm -rf "lv2-gtk-ui-bridge"
fi

git clone https://github.com/falkTX/lv2-gtk-ui-bridge.git lv2-gtk-ui-bridge
cd lv2-gtk-ui-bridge
make
mv lv2-gtk-ui-bridge.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
cd ..

rm -rf "lv2-gtk-ui-bridge"
