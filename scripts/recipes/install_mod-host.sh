#!/bin/bash

# Mod-Host
cd $ZYNTHIAN_SW_DIR


if [ -d "mod-host" ]; then
	rm -rf "mod-host"
fi

#MOD_HOST_GITSHA="0d1cb5484f5432cdf7fa297e0bfcc353d8a47e6b"

git clone https://github.com/moddevices/mod-host.git
cd mod-host
if [[ -n $MOD_HOST_GITSHA ]]; then
	git branch -f zynthian $MOD_HOST_GITSHA
	git checkout zynthian
fi

make -j 3
make install
make clean

cd ..
rm -rf "mod-host"