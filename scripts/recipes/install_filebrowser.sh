#!/bin/bash

version="2.63.23"

if [ ${MACHINE_HW_NAME} = "armv7l" ]; then
	filename="linux-armv5-filebrowser.tar.gz"
elif [ ${MACHINE_HW_NAME} = "aarch64" ]; then
	filename="linux-arm64-filebrowser.tar.gz"
elif [ ${MACHINE_HW_NAME} = "x86_64" ]; then
	filename="linux-amd64-filebrowser.tar.gz"
else
	exit 0
fi

cd $ZYNTHIAN_SW_DIR
if [ -d filebrowser ]; then
	rm -rf filebrowser
fi
mkdir filebrowser
cd filebrowser
wget "https://github.com/filebrowser/filebrowser/releases/download/v$version/$filename"
tar xfvz "$filename"
rm -f "$filename"
cp -a $ZYNTHIAN_SYS_DIR/etc/filebrowser/* .
cd ..
