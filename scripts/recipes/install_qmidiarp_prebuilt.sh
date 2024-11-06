#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2
rm -rf qmidiarp_*.lv2
wget "$BASE_URL_DOWNLOAD/qmidiarp.tar.xz"
tar xfv "qmidiarp.tar.xz"
mv qmidiarp/qmidiarp_*.lv2 .
mv qmidiarp/.qmidiarprc /root
rm -rf qmidiarp
rm -f "qmidiarp.tar.xz"
