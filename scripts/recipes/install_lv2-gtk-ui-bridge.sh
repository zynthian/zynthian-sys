#!/bin/bash

#apt-get -y install libgtk2.0-dev libgtk-3-dev liblilv-dev lv2-dev libx11-dev make pkg-config

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "lv2-gtk-ui-bridge" ]; then
	rm -rf "lv2-gtk-ui-bridge"
fi

git clone https://github.com/falkTX/lv2-gtk-ui-bridge.git lv2-gtk-ui-bridge
cd lv2-gtk-ui-bridge
make
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/lv2-gtk-ui-bridge.lv2
mv lv2-gtk-ui-bridge.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

# Add missing plugins with deprecated Gtk2/Gtk3 UIs
manifest_fpath=$ZYNTHIAN_PLUGINS_DIR/lv2/lv2-gtk-ui-bridge.lv2/manifest.ttl
echo "
<http://code.google.com/p/amsynth/amsynth>
    ui:ui gtk2: .

<http://nickbailey.co.nr/triceratops>
    ui:ui gtk2: .

<http://github.com/nicklan/drmr>
    ui:ui gtk2: .
" >> "$manifest_fpath"

cd ..
rm -rf "lv2-gtk-ui-bridge"
