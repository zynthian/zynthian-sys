#!/bin/bash

cd $ZYNTHIAN_SW_DIR

version=1.1.0
dname=libsndfile-$version

if [ -d "$dname" ]; then
	rm -rf $dname
fi

wget https://github.com/libsndfile/libsndfile/releases/download/$version/$dname.tar.xz
tar xf $dname.tar.xz
rm -f $dname.tar.xz

cd $dname
./configure
make -j 3
make install

cd ..
rm -rf $dname
