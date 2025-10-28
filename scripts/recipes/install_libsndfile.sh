#!/bin/bash

cd $ZYNTHIAN_SW_DIR

#version=1.1.0
#dname=libsndfile-$version
dname=libsndfile

if [ -d "$dname" ]; then
	rm -rf $dname
fi

#wget https://github.com/libsndfile/libsndfile/releases/download/$version/$dname.tar.xz
#tar xf $dname.tar.xz
#rm -f $dname.tar.xz

git clone -b zynthian https://github.com/riban-bw/libsndfile

cd $dname
#./configure
mkdir build
cd build
cmake ..
make -j 3
make install

cd ..
rm -rf $dname
