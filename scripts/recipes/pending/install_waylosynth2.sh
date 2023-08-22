#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "waylosynth2" ]; then
	rm -rf "waylosynth2"
fi

git clone --recursive https://github.com/zynthian/waylosynth2.git
cd waylosynth2
sed -i 's/HOME\)\/JUCE/JUCE_DIR\)/' ./Builds/LinuxMakefile/Makefile
sed -i 's/\~\/JUCE/\$\(JUCE_DIR\)/' ./Builds/LinuxMakefile/Makefile
make -j 3
make install
make clean
cd ..
rm -rf "waylosynth2"

