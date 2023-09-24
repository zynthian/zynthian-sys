#!/bin/bash

# Mod-Host
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/moddevices/mod-host.git
cd mod-host

if [[ -n $MOD_HOST_GITSHA ]]; then
	git branch -f zynthian $MOD_HOST_GITSHA
	git checkout zynthian
fi

make -j 4
make install
make clean
