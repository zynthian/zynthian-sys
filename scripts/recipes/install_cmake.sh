#!/bin/bash

$VERSION="v3.20.0-rc4"

# riban LV2 plugins
cd $ZYNTHIAN_sw_DIR

if [ -d cmake-$VERSION ]; then
	rm -rf cmake-$VERSION
fi

apt-get -y install openssl-dev

wget https://gitlab.kitware.com/cmake/cmake/-/archive/v3.20.0-rc4/cmake-$VERSION.tar.gz
tar xfvz cmake-$VERSION.tar.gz
cd cmake-$VERSION
./bootstrap --prefix=/usr/local
./configure

