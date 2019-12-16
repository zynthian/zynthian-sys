#!/bin/bash

# Uninstall official wiringpi deb package
apt -y remove wiringpi

# Build and install WiringPi library
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/steveb/WiringPi
cd WiringPi
./build
cd ..
