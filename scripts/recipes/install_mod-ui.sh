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
# pycrypto is abandoned and does not build on Python 3.13; pycryptodome is its maintained drop-in (the Crypto.* modules
# mod-ui imports). tornado 4.3 needs the ssl_match_hostname backport once Python 3.12 dropped the standard one.
grep -v -i "pycrypto" requirements.txt > requirements.nocrypto.txt
pip3 install -r requirements.nocrypto.txt
pip3 install pycryptodome backports.ssl_match_hostname
rm -f requirements.nocrypto.txt
pip3 install browsepy
# the compatibility edits below name the environment's own Python version, not a fixed one
PYVER=$(python3 -c 'import sys; print("%d.%d" % sys.version_info[:2])')
# Patch library to work with old tornado version (4.3!)
sed -i -e 's/collections.MutableMapping/collections.abc.MutableMapping/' modui-env/lib/python$PYVER/site-packages/tornado/httputil.py
sed -i -e 's/collections.Mapping/collections.abc.Mapping/' modui-env/lib/python$PYVER/site-packages/browsepy/manager.py
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
