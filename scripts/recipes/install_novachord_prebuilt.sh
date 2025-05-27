#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2

wget "$BASE_URL_DOWNLOAD/novachord.lv2.tar.xz"
tar xfv "novachord.lv2.tar.xz"
rm -f "novachord.lv2.tar.xz"

