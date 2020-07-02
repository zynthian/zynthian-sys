#!/bin/bash

# Install DISTRHO DPF plugins

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "DPF-Plugins" ]; then
	rm -rf "DPF-Plugins"
fi

# Get source code
git clone https://github.com/DISTRHO/DPF-Plugins.git
cd DPF-Plugins

# Avoid errors while installing binaries
sed -i -- 's/cp \-r bin\/ProM/\#cp \-r bin\/ProM/' Makefile
sed -i -- 's/cp \-r bin\/glBars/\#cp \-r bin\/glBars/' Makefile

# Build
export NOOPT=true
make -j 3
make install
make clean

cd ..
rm -rf "DPF-Plugins"
