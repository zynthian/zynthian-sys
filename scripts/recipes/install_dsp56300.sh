#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "gearemulator" ]; then
    rm -rf "gearemulator"
fi

git clone --recurse-submodules https://github.com/dsp56300/gearmulator.git
cd gearemulator
umount /tmp
cmake --preset zynthian
cmake --build --preset zynthian --target install
mount /tmp

cd ..
#rm -rf "gearemulator"
