#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2 || exit
if [ -d "Osirus.lv2" ]; then
	rm -rf Osirus.lv2
fi
if [ -d "OsTIrus.lv2" ]; then
	rm -rf OsTIrus.lv2
fi
if [ -d "Vavra.lv2" ]; then
	rm -rf Vavra.lv2
fi
if [ -d "Xenia.lv2" ]; then
	rm -rf Xenia.lv2
fi
if [ -d "Nodal2X.lv2" ]; then
	rm -rf Nodal2X.lv2
fi
if [ -d "JE8086.lv2" ]; then
	rm -rf JE8086.lv2
fi
wget "$BASE_URL_DOWNLOAD/TheUsualSuspects.tar.xz"
tar xfv "TheUsualSuspects.tar.xz"
mv TheUsualSuspects/Osirus.lv2 .
mv TheUsualSuspects/OsTIrus.lv2 .
mv TheUsualSuspects/Vavra.lv2 .
mv TheUsualSuspects/Xenia.lv2 .
mv TheUsualSuspects/Nodal2X.lv2 .
mv TheUsualSuspects/JE8086.lv2 .

rm -rf TheUsualSuspects
rm -f "TheUsualSuspects.tar.xz"
