# DISTRHO ports

#REQUIRE:

cd $ZYNTHIAN_PLUGINS_SRC_DIR

#Download and compile code from github
git clone https://github.com/DISTRHO/DISTRHO-Ports.git
cd DISTRHO-Ports
export LINUX_EMBED=true
./scripts/premake-update.sh linux
#make -j 3 lv2
make -j 1 lv2
make install
make clean
make distclean

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
ln -s $LV2_LOCAL/TheFunction.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/ThePilgrim.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/drowaudio-distortion.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/drowaudio-distortionshaper.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/drowaudio-flanger.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/drowaudio-reverb.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/drowaudio-tremolo.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/Luftikus.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/Obxd.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-Dub-3.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-Filter-2.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-Filter.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-NoiseMaker.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-NoiseMaker-Noise4U.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-Reverb-2.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-Reverb-3.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-Reverb.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/TAL-Vocoder-2.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/Vex.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s $LV2_LOCAL/Wolpertinger.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
