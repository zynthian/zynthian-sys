#!/bin/bash

# JUCE framework
# It probably needs to increase /tmp space to 200MB (-j > 1)

cd $ZYNTHIAN_SW_DIR

if [ -d "JUCE" ]; then
	rm -rf JUCE
fi

git clone https://github.com/juce-framework/JUCE.git
cd JUCE
mkdir build
cd build
cmake ..
make install
cd ..

cd ./extras/Projuicer/Builds/LinuxMakefile
make CONFIG=Release
#make CONFIG=Release -j 2
cp -a /build/Projuicer /usr/local/bin
mv /build/Projuicer $ZYNTHIAN_SW_DIR/JUCE

cd $ZYNTHIAN_SW_DIR
#rm -rf JUCE

