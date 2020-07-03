#!/bin/bash

# DISTRHO ports

#REQUIRE:

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "DISTRHO-Ports" ]; then
	rm -rf "DISTRHO-Ports"
fi
#Download and compile code from github
git clone https://github.com/DISTRHO/DISTRHO-Ports.git
cd DISTRHO-Ports
export LINUX_EMBED=true
./scripts/premake-update.sh linux

# Workaround for https://github.com/zynthian/zynthian-sys/issues/59
# Caused by https://bugs.launchpad.net/qemu/+bug/1776478
sed -i 's@\t\@./scripts/generate-ttl.sh@\t@g' Makefile

make -j 3 lv2
make install
make clean
make distclean

cd ..
rm -rf DISTRHO-Ports
