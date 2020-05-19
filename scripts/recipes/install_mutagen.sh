#!/bin/bash

# mutagen: audio file metadata
cd $ZYNTHIAN_SW_DIR
if [ -d "mutagen" ]; then
	rm -rf "mutagen"
fi

git clone https://github.com/quodlibet/mutagen.git
cd mutagen
python3 ./setup.py install
cd ..

rm -rf "mutagen"
