#!/bin/bash

# DISTRHO DPF plugins

#REQUIRE:

cd $ZYNTHIAN_PLUGINS_SRC_DIR

#Download and compile code from github
git clone https://github.com/DISTRHO/DPF-Plugins.git
cd DPF-Plugins
export NOOPT=true
make -j 3
make install
make clean

#Remove pre-existing plugins
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/3BandEQ.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/3BandSplitter.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/AmplitudeImposer.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/CycleShifter.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/glBars.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Kars.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/MaBitcrush.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/MaFreeverb.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/MaGigaverb.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/MaPitchshift.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/MVerb.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Nekobi.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/PingPongPan.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/SoulForce.lv2

#Create symlinks to LV2
export LV2_LOCAL=/usr/local/lib/lv2
ln -s $LV2_LOCAL/3BandEQ.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/3BandSplitter.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/AmplitudeImposer.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/CycleShifter.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/glBars.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/Kars.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/MaBitcrush.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/MaFreeverb.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/MaGigaverb.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/MaPitchshift.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/MVerb.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/Nekobi.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/PingPongPan.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/SoulForce.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
