#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "AIDA-X-1.1.0" ]; then
	rm -rf "AIDA-X-1.1.0"
fi

wget https://github.com/AidaDSP/AIDA-X/releases/download/1.1.0/AIDA-X-1.1.0-linux-arm64.tar.xz
tar xf AIDA-X-1.1.0-linux-arm64.tar.xz
mv AIDA-X-1.1.0/AIDA-X.lv2 /usr/local/lib/lv2/

rm -f AIDA-X-1.1.0-linux-arm64.tar.xz
rm -rf "AIDA-X-1.1.0"
