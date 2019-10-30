#!/bin/bash

# mod-sdk
cd $ZYNTHIAN_SW_DIR
git clone --recursive https://github.com/moddevices/mod-sdk.git
cd mod-sdk/utils
make
cd ../..
#cd mod-sdk
#python3 setup.py build
#python3 setup.py install
#cd ..
