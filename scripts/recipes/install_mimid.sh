#!/bin/bash

# Pulluxsynth Audio Plugins (MiMi-d)

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "polluxsynth-audio-plugins" ]; then
	rm -rf "polluxsynth-audio-plugins"
fi

#wget https://github.com/polluxsynth/audio-plugins/archive/refs/tags/2.1.2z.tar.gz
#tar xfvz 2.1.2z.tar.gz
#rm -f 2.1.2z.tar.gz
#mv audio-plugins-2.1.2z polluxsynth-audio-plugins

git clone --recursive -b zynthian https://github.com/polluxsynth/audio-plugins polluxsynth-audio-plugins
cd polluxsynth-audio-plugins
make -j 3
make install
make clean

cd ..
rm -rf "polluxsynth-audio-plugins"
