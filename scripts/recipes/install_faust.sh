#!/bin/bash

# Faust
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/grame-cncm/faust.git
cd faust
git submodule update --init
make -j 3
make install
cd ..
rm -rf faust

# Granulator plugin
cd /usr/local/share/faust/examples/bela
faust2lv2 granulator.dsp
cp -a granulator.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

# Alternate Granulator plugin
cd $ZYNTHIAN_SW_DIR/plugins
git clone https://github.com/zynthian/faust-code
cd faust-code
faust2lv2 granulator_e7mac.dsp
cp -a granulator_e7mac.dsp.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
cd ..
rm -rf faust-code

