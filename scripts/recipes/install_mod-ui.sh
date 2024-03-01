#!/bin/bash

# mod-ui

cd $ZYNTHIAN_SW_DIR

# Delete prvious isntall to start from scratch
if [ -d "mod-ui" ]; then
	rm -rf "mod-ui"
fi

# Download source code
git clone --recursive --single-branch --branch zyn-mod-merge-next https://github.com/zynthian/mod-ui.git
cd mod-ui

# Checkout specific branch if requested
if [[ -n $MOD_UI_GITSHA ]]; then
	git branch -f zynthian $MOD_UI_GITSHA
	git checkout zynthian
fi

# Install python modules
pip3 install pyserial==3.0 pystache==0.5.4 aggdraw==1.3.11
# This fails!!! Pycrypto is archived!!
pip3 install git+git://github.com/dlitz/pycrypto@master#egg=pycrypto

# Build utils
cd utils
make

# Create data directory
if [ ! -d "$ZYNTHIAN_SW_DIR/mod-ui/data" ]; then
	mkdir "$ZYNTHIAN_SW_DIR/mod-ui/data"
fi
