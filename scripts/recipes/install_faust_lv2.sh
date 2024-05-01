#!/bin/bash

# faust LV2 plugins
cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d faust-lv2 ]; then
	rm -rf faust-lv2
fi

git clone https://bitbucket.org/agraef/faust-lv2
cd faust-lv2
make -j 4
make install
#make install-faust

wget https://raw.githubusercontent.com/e7mac/faust-code/master/granulator.dsp
faust2lv2 granulator.dsp
mv granulator.lv2 /zynthian/zynthian-plugins/lv2

cd ..
rm -rf faust-lv2
