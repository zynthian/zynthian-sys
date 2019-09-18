#!/bin/bash

# Install prebuilt binaries of DISTRHO ports + Helm

#REQUIRE:

cd $ZYNTHIAN_PLUGINS_SRC_DIR

#Download pre-compiled plugins from github
git clone https://github.com/zynthian/lv2-plugins-prebuilt-rbpi3.git
cd lv2-plugins-prebuilt-rbpi3

# Create symlinks in zynthian plugins dir
PLUGINS=( helm TheFunction ThePilgrim drowaudio-distortion drowaudio-distortionshaper drowaudio-flanger drowaudio-reverb drowaudio-tremolo Luftikus Obxd TAL-Dub-3 TAL-Filter-2 TAL-Filter TAL-NoiseMaker TAL-NoiseMaker-Noise4U TAL-Reverb-2 TAL-Reverb-3 TAL-Reverb TAL-Vocoder-2 Vex Wolpertinger )

for u in "${PLUGINS[@]}"; do
	#Remove pre-existing plugin
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/$u.lv2
	#Create symlinks to LV2
	ln -s $ZYNTHIAN_PLUGINS_SRC_DIR/lv2-plugins-prebuilt-rbpi3/$u.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
done

cd ..
