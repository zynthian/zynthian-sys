#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2
rm -rf Osirus.lv2
rm -rf OsTIrus.lv2
wget "$BASE_URL_DOWNLOAD/dsp56300.tar.xz"
tar xfv "dsp56300.tar.xz"
mv dsp56300/Osirus.lv2 .
mv dsp56300/OsTIrus.lv2 .
mv dsp56300/bin/* /usr/local/bin
rm -rf dsp56300
rm -f "dsp56300.tar.xz"
