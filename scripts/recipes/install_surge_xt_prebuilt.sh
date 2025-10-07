#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2

wget "$BASE_URL_DOWNLOAD/Surge XT.lv2.tar.xz"
tar xfv "Surge XT.lv2.tar.xz"
rm -f "Surge XT.lv2.tar.xz"

wget "$BASE_URL_DOWNLOAD/Surge XT Effects.lv2.tar.xz"
tar xfv "Surge XT Effects.lv2.tar.xz"
rm -f "Surge XT Effects.lv2.tar.xz"

cd /usr/local/share

wget "$BASE_URL_DOWNLOAD/surge-xt.tar.xz"
tar xfv "surge-xt.tar.xz"
rm -f "surge-xt.tar.xz"

if [ ! -d "/root/.Surge XT" ]; then
	mkdir "/root/.Surge XT"
fi