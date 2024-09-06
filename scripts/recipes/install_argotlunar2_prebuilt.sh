#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2

wget "$BASE_URL_DOWNLOAD/argotlunar2.lv2.tar.xz"
tar xfv "argotlunar2.lv2.tar.xz"
rm -f "argotlunar2.lv2.tar.xz"

