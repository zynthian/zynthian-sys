#!/bin/bash

# Install ZAM plugins

# Get source code
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "zam-plugins" ]; then
	rm -rf "zam-plugins"
fi

git clone https://github.com/zamaudio/zam-plugins.git
cd zam-plugins
git submodule update --init

# Build
export NOOPT=true
make -j 4
make install
make clean
cd ..
rm -rf "zam-plugins"
