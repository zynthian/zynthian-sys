#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ -d "bluez-alsa" ]; then
	rm -rf "bluez-alsa"
fi

apt-get install --yes libbluetooth-dev libsbc-dev libfdk-aac-dev zita-ajbridge

git clone --depth 1 --branch v4.0.0 https://github.com/Arkq/bluez-alsa.git
cd bluez-alsa
autoreconf --install --force
mkdir build
cd build
../configure  --enable-systemd --enable-aac
make
make install

