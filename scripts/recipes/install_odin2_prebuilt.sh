#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2

wget "$BASE_URL_DOWNLOAD/Odin2.lv2.tar.xz"
tar xfv "Odin2.lv2.tar.xz"
rm -f "Odin2.lv2.tar.xz"

