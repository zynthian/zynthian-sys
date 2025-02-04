#!/bin/bash

# Pulluxsynth Audio Plugins (MiMi-d)

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "polluxsynth-audio-plugins" ]; then
	rm -rf "polluxsynth-audio-plugins"
fi

git clone --recursive https://github.com/polluxsynth/audio-plugins polluxsynth-audio-plugins
cd polluxsynth-audio-plugins
make -j3
make install
make clean

cd ..
rm -rf "polluxsynth-audio-plugins"
