#!/bin/bash

# DISTRHO ports

#REQUIRE:

cd $ZYNTHIAN_PLUGINS_SRC_DIR

#Download pre-compiled plugins from github
git clone https://github.com/zynthian/DISTRHO-Ports-prebuilt-rbpi3.git
cd DISTRHO-Ports-prebuilt-rbpi3

#Remove pre-existing plugins
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TheFunction.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/ThePilgrim.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/drowaudio-distortion.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/drowaudio-distortionshaper.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/drowaudio-flanger.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/drowaudio-reverb.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/drowaudio-tremolo.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Luftikus.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Obxd.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-Dub-3.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-Filter-2.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-Filter.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-NoiseMaker.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-NoiseMaker-Noise4U.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-Reverb-2.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-Reverb-3.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-Reverb.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/TAL-Vocoder-2.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Vex.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Wolpertinger.lv2

#Create symlinks to LV2
export LV2_LOCAL=/usr/local/lib/lv2
mv ./TheFunction.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./ThePilgrim.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./drowaudio-distortion.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./drowaudio-distortionshaper.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./drowaudio-flanger.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./drowaudio-reverb.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./drowaudio-tremolo.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./Luftikus.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./Obxd.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-Dub-3.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-Filter-2.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-Filter.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-NoiseMaker.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-NoiseMaker-Noise4U.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-Reverb-2.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-Reverb-3.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-Reverb.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./TAL-Vocoder-2.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./Vex.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
mv ./Wolpertinger.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd ..
