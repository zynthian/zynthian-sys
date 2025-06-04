#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd /usr/local/lib/lv2
if [-d "Osirus.lv2" ]; then
	rm -rf Osirus.lv2
fi
if [-d "OsTIrus.lv2" ]; then
	rm -rf OsTIrus.lv2
fi
if [-d "Vavra.lv2" ]; then
	rm -rf Vavra.lv2
fi
if [-d "Xenia.lv2" ]; then
	rm -rf Xenia.lv2
fi
wget "$BASE_URL_DOWNLOAD/dsp56300.tar.xz"
tar xfv "dsp56300.tar.xz"
mv dsp56300/Osirus.lv2 .
mv dsp56300/OsTIrus.lv2 .
mv dsp56300/Vavra.lv2 .
mv dsp56300/Xenia.lv2 .

rm -rf dsp56300
rm -f "dsp56300.tar.xz"
