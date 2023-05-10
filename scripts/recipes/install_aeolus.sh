#!/bin/bash

cd $ZYNTHIAN_SW_DIR

#Delete legacy build if it exists
if [ -d "kokkinizita" ]; then
	rm -rf kokkinizita
fi

if [ ! -d "aeolus" ]; then
git clone https://github.com/riban-bw/aeolus.git
fi

cd aeolus/source
git checkout zynthian
git pull
make
make install

cd ..
