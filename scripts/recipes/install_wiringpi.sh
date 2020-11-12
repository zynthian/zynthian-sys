#!/bin/bash

# Uninstall official wiringpi deb package
apt-get -y remove wiringpi

# Build and install WiringPi library
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/WiringPi/WiringPi.git
cd WiringPi
./build
cd ..
