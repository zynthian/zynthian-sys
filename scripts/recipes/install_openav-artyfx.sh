#!/bin/bash

# openav-artyfx.sh

export CXXFLAGS="$CFLAGS -fpermissive"

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "openAV-ArtyFX" ]; then
	rm -rf "openAV-ArtyFX"
fi

git clone https://github.com/openAVproductions/openAV-ArtyFX.git
cd openAV-ArtyFX
sed -i -- 's/ lib\/lv2\// \/zynthian\/zynthian-plugins\/lv2\//' CMakeLists.txt
#cmake -DBUILD_GUI=OFF -DBUILD_SSE=OFF .
cmake .
make -j 4
make install
make clean
cd ..

rm -rf "openAV-ArtyFX"
