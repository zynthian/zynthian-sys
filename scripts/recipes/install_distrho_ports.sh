#!/bin/bash

# DISTRHO ports

#REQUIRE:

cd $ZYNTHIAN_PLUGINS_SRC_DIR

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

# Create symlinks in zynthian plugins dir
LV2_LOCAL_DIR=/usr/local/lib/lv2
PLUGINS=( TheFunction ThePilgrim drowaudio-distortion drowaudio-distortionshaper drowaudio-flanger drowaudio-reverb drowaudio-tremolo Luftikus Obxd TAL-Dub-3 TAL-Filter-2 TAL-Filter TAL-NoiseMaker TAL-NoiseMaker-Noise4U TAL-Reverb-2 TAL-Reverb-3 TAL-Reverb TAL-Vocoder-2 Vex Wolpertinger )

for u in "${PLUGINS[@]}"; do
	#Remove pre-existing plugin
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/$u.lv2
	#Create symlinks to LV2
	ln -s $LV2_LOCAL_DIR/$u.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
done
