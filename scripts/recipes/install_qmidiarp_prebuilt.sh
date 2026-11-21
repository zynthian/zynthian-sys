#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/${MACHINE_HW_NAME}"
FILENAME="qmidiarp.tar.xz"

cd $ZYNTHIAN_PLUGINS_DIR
wget "$BASE_URL_DOWNLOAD/$FILENAME"
if [ ! -f "$FILENAME" ]; then
    echo "Can't download '$BASE_URL_DOWNLOAD/$FILENAME'"
    exit
fi
rm -rf lv2/qmidiarp_*.lv2
tar xfv "$FILENAME"
mv qmidiarp/qmidiarp_*.lv2 lv2
mv qmidiarp/.qmidiarprc /root
rm -rf qmidiarp
rm -f "$FILENAME"
