#!/bin/bash

# Uninstall official wiringpi deb package
apt-get -y remove wiringpi

cd $ZYNTHIAN_SW_DIR

# Remove previous sources
if [ -d "./WiringPi" ]; then
	rm -rf "./WiringPi"
fi

# Download, build and install WiringPi library
#git clone https://github.com/WiringPi/WiringPi.git
git clone https://github.com/zynthian/WiringPi.git
cd WiringPi
./build
cd ..
