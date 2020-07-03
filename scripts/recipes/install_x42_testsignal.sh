#!/bin/bash

# Install X42 testsignal plugin

# Get source code
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone git://github.com/x42/testsignal.lv2.git

# Build
cd testsignal.lv2
make -j 4
make install PREFIX=/usr/local
make clean

