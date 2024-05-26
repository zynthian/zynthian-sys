#!/bin/bash

cd $ZYNTHIAN_SW_DIR

if [ -d "pyliblo" ]; then
	rm -rf pyliblo
fi

git clone https://github.com/dsacre/pyliblo.git
cd pyliblo
pip3 install .
cd ..

rm -rf pyliblo
