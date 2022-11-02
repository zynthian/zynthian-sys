#!/bin/bash

# Install prebuilt binaries of DISTRHO ports + Helm

REPONAME="lv2-plugins-prebuilt-rbpi3"

cd $ZYNTHIAN_PLUGINS_SRC_DIR

#Delete old version if exists
if [ -d "./$REPONAME" ]; then
	rm -rf "./$REPONAME"
fi

#Download pre-compiled plugins from github
git clone https://github.com/zynthian/$REPONAME.git
cd $REPONAME

# Create symlinks in zynthian plugins dir
#PLUGINS=( helm TheFunction ThePilgrim drowaudio-distortion drowaudio-distortionshaper drowaudio-flanger drowaudio-reverb drowaudio-tremolo Luftikus Obxd TAL-Dub-3 TAL-Filter-2 TAL-Filter TAL-NoiseMaker TAL-NoiseMaker-Noise4U TAL-Reverb-2 TAL-Reverb-3 TAL-Reverb TAL-Vocoder-2 Vex Wolpertinger granulator argotlunar2 )
PLUGINS=( granulator argotlunar2 OS-251 Odin2 )

for u in "${PLUGINS[@]}"; do
	#Remove pre-existing plugin
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/$u.lv2
	#Create symlinks to LV2
	ln -s $ZYNTHIAN_PLUGINS_SRC_DIR/$REPONAME/$u.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
done

cd ..
