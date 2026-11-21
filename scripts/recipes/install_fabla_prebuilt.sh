#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/${MACHINE_HW_NAME}"
FILENAME="fabla.tar.xz"

cd $ZYNTHIAN_PLUGINS_DIR
wget "$BASE_URL_DOWNLOAD/$FILENAME"
if [ ! -f "$FILENAME" ]; then
    echo "Can't download '$BASE_URL_DOWNLOAD/$FILENAME'"
fi
tar xfv "$FILENAME"
rm -rf lv2/fabla*.lv2
rm -rf lv2-presets/fabla*.lv2
mv fabla/fabla.lv2 lv2
mv fabla/fabla*.lv2 lv2-presets
rm -rf fabla
rm -f "$FILENAME"
regenerate_lv2_presets.sh http://www.openavproductions.com/fabla
