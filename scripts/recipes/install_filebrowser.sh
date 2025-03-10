#!/bin/bash

cd $ZYNTHIAN_SW_DIR

if [ -d filebrowser ]; then
	rm -rf filebrowser
fi
mkdir filebrowser
cd filebrowser
wget https://github.com/filebrowser/filebrowser/releases/download/v2.32.0/linux-arm64-filebrowser.tar.gz
tar xfvz linux-arm64-filebrowser.tar.gz
rm -f linux-arm64-filebrowser.tar.gz
cp -a $ZYNTHIAN_SYS_DIR/etc/filebrowser/* .
cd ..
