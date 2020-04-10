#!/bin/bash

# njconnect

cd $ZYNTHIAN_PLUGINS_SRC_DIR
svn checkout https://svn.code.sf.net/p/njconnect/code/trunk njconnect
cd njconnect
make -j 4
make install
make clean
cd ..
