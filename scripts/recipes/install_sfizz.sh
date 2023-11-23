#!/bin/bash

cd ${ZYNTHIAN_SW_DIR}

if [ -d "sfizz" ]; then
	rm -rf "sfizz"
fi

git clone https://github.com/sfztools/sfizz.git sfizz
#git clone https://github.com/zynthian/sfizz.git sfizz
cd sfizz
mkdir build
cd build
git submodule update --init --recursive
cmake ..
make -j 4
make install

