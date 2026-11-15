#!/bin/bash

# Install MediaMTX (realtime media server): serves the audio stream (WebRTC/WHEP) of
# jack2whip.service (zynthian-sys/etc/systemd), used by the Zynthian remote page.

version="1.21.3"

if [ ${MACHINE_HW_NAME} = "aarch64" ]; then
	arch="arm64"
elif [ ${MACHINE_HW_NAME} = "armv7l" ]; then
	arch="armv7"
elif [ ${MACHINE_HW_NAME} = "x86_64" ]; then
	arch="amd64"
else
	exit 0
fi
filename="mediamtx_v${version}_linux_${arch}.tar.gz"

cd $ZYNTHIAN_SW_DIR
mkdir -p mediamtx
cd mediamtx
wget "https://github.com/bluenviron/mediamtx/releases/download/v$version/$filename"
tar xfvz "$filename"
mv mediamtx /usr/local/bin
mkdir -p /usr/local/etc/mediamtx
# Keep an existing configuration
if [ -f /usr/local/etc/mediamtx/mediamtx.yml ]; then
	mv mediamtx.yml /usr/local/etc/mediamtx/mediamtx.yml.dist
else
	mv mediamtx.yml /usr/local/etc/mediamtx
fi
cd ..
rm -rf mediamtx
