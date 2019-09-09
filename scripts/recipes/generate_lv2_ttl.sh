#!/bin/bash

# Build and install lv2_ttl_generator
cd $ZYNTHIAN_PLUGINS_SRC_DIR/helm/builds/linux/LV2
make ttl_generator
cp ./lv2_ttl_generator /usr/local/bin

# Generate presets for some plugins
PLUGINS=( helm TheFunction ThePilgrim drowaudio-distortion drowaudio-distortionshaper drowaudio-flanger drowaudio-reverb drowaudio-tremolo Luftikus Obxd TAL-Dub-3 TAL-Filter-2 TAL-Filter TAL-NoiseMaker TAL-NoiseMaker-Noise4U TAL-Reverb-2 TAL-Reverb-3 TAL-Reverb TAL-Vocoder-2 Vex Wolpertinger )

for u in "${PLUGINS[@]}"; do
	cd $ZYNTHIAN_PLUGINS_DIR/lv2/$u.lv2
	/usr/local/bin/lv2_ttl_generator $u.so
done
