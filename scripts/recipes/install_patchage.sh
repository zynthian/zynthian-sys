#!/bin/bash

# patchage

if [[ "$RBPI_VERSION_NUMBER" == "3" ]]; then
  exit 0 # RPi3 currently has a problem building patchage
fi

cd $ZYNTHIAN_SW_DIR

if [ -d "patchage" ]; then
	rm -rf "patchage"
fi

git clone https://github.com/drobilla/patchage.git
cd patchage
meson setup build
cd build
meson compile -j 3
meson install

cd ../..
rm -rf "patchage"