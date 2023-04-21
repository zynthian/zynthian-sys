#!/bin/bash

# qmidinet
cd $ZYNTHIAN_SW_DIR

if [ -d "qmidinet" ]; then
	rm -rf "qmidinet"
fi

git clone https://github.com/rncbc/qmidinet.git
cd qmidinet
./autogen.sh
./configure
make -j 3
make install
cd ..
