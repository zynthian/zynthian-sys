#!/bin/bash

# jackrtpmidid

cd $ZYNTHIAN_SW_DIR

if [ -d "bbouchez" ]; then
	rm -rf "bbouchez"
fi
mkdir bbouchez
cd bbouchez

git clone https://github.com/bbouchez/BEBSDK
git clone https://github.com/bbouchez/RTP-MIDI
git clone https://github.com/bbouchez/jackrtpmidid
cd jackrtpmidid/jackrtpmidid
sed -i "s#../../../../../SDK/beb/common_src#../../BEBSDK#g" nbproject/Makefile-Release.mk
sed -i "s#../../../../../SDK/beb/common_src#../../BEBSDK#g" nbproject/Makefile-Debug.mk
make CONF=Release
cp ./dist/Release/GNU-Linux/jackrtpmidid /usr/local/bin

# Roll-back to pre-IPv6 version
#git checkout ccbdb58
#make
#cp ./dist/Debug/GNU-Linux/jackrtpmidid /usr/local/bin

cd $ZYNTHIAN_SW_DIR
rm -rf "bbouchez"
