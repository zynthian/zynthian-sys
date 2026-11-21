#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
plugin_name="Ultramaster KR-106"

cd $plugins_path
rm -rf "./$plugin_name.lv2"

VERSION="v2.2.2"
if [ ${MACHINE_HW_NAME} = "aarch64" ]; then
    FILENAME="KR106-Linux-arm64.zip"
elif [ ${MACHINE_HW_NAME} = "x86_64" ]; then
    FILENAME="KR106-Linux.zip"
else
    echo "Platform ${MACHINE_HW_NAME} not supported!"
    exit
fi
wget "https://github.com/kayrockscreenprinting/ultramaster_kr106/releases/download/$VERSION/$FILENAME"
unzip -o "$FILENAME"
rm -rf "$plugin_name"
rm -rf "$plugin_name.vst3"
rm -rf "$plugin_name.clap"
rm -f "README.md"
rm -f "INSTALL.txt"
rm -f "$FILENAME"

#BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"
#FILENAME="$plugin_name.lv2.tar.xz"
#wget "$BASE_URL_DOWNLOAD/$FILENAME"
#tar xfv "$FILENAME"
#rm -f "$FILENAME"

