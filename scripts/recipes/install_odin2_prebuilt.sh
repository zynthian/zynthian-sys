#!/bin/bash

if [ ${MACHINE_HW_NAME} = "aarch64" ]; then
    BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"
    cd $ZYNTHIAN_PLUGINS_DIR/lv2
    wget "$BASE_URL_DOWNLOAD/Odin2.lv2.tar.xz"
    tar xfv "Odin2.lv2.tar.xz"
    rm -f "Odin2.lv2.tar.xz"
elif [ ${MACHINE_HW_NAME} = "x86_64" ]; then
    FILENAME="Odin2-synth_2.4-1.deb"
    cd $ZYNTHIAN_SW_DIR/plugins
    wget "https://github.com/TheWaveWarden/odin2/releases/download/NightlyDevel/$FILENAME"
    dpkg -i "$FILENAME"
    rm -f $FILENAME
else
    echo "Platform ${MACHINE_HW_NAME} not supported!"
    exit
fi


