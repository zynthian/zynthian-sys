#!/bin/bash

# mod-ui

cd $ZYNTHIAN_SW_DIR

# Delete prvious install to start from scratch
if [ -d "mod-ui" ]; then
	rm -rf "mod-ui"
fi

# Download source code
git clone --recursive --single-branch --branch zyn-mod-merge-20230514 https://github.com/zynthian/mod-ui.git
cd mod-ui
# Create python vitual env
python3 -m venv modui-env --system-site-packages
source modui-env/bin/activate
# Install python requirements
pip3 install -r requirements.txt
pip3 install browsepy
# Patch library to work with old tornado version (4.3!)
sed -i -e 's/collections.MutableMapping/collections.abc.MutableMapping/' modui-env/lib/python3.11/site-packages/tornado/httputil.py
sed -i -e 's/collections.Mapping/collections.abc.Mapping/' modui-env/lib/python3.11/site-packages/browsepy/manager.py
# Build utils library
make -C utils

# Create data directory
if [ ! -d "$ZYNTHIAN_SW_DIR/mod-ui/data" ]; then
	mkdir "$ZYNTHIAN_SW_DIR/mod-ui/data"
fi

# Create link to browsepy
if [ ! -f "/usr/local/bin/browsepy" ]; then
	ln -s "$ZYNTHIAN_SW_DIR/mod-ui/modui-env/bin/browsepy" "/usr/local/bin/browsepy"
fi
