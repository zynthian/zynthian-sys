#!/bin/bash

#Aeolus Pipe Organ Emulator

cd $ZYNTHIAN_SW_DIR

#Delete legacy build if it exists
if [ -d "kokkinizita" ]; then
	rm -rf kokkinizita
fi
if [ -d "aeolus" ]; then
	rm -rf aeolus
fi

if [ ! -d "aeolus" ]; then
git clone https://github.com/riban-bw/aeolus.git
fi
cd aeolus/source
git checkout zynthian
git pull
make -j 3
make install
make clean

#Copy stops configurations
cd ..
if [ ! -d "/usr/local/share/aeolus" ]; then
	mkdir "/usr/local/share/aeolus"
fi
cp -a stops "/usr/local/share/aeolus"

# Create global configuration file
echo "-u -S /usr/local/share/aeolus/stops" > /etc/aeolus.conf

cd ..
