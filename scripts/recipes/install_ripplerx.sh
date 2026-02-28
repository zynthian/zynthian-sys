#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR


if [ -d "ripplerx"]; then
	rm -rf "ripplerx"
fi

git clone --recurse-submodules https://github.com/tiagolr/ripplerx.git
cd ripplerx

# Add "-fPIC" option to CMake config file
#sed -i "s#set(CMAKE_CXX_STANDARD 17)#set(CMAKE_CXX_STANDARD 17)\nset(CMAKE_CXX_FLAGS \"-fPIC\")#" CMakeLists.txt
sed -i "s#set(CMAKE_CXX_STANDARD 17)#set(CMAKE_CXX_STANDARD 17)\nset(CMAKE_POSITION_INDEPENDENT_CODE ON)#" CMakeLists.txt

# Build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -S . -B ./build
cmake --build ./build --config Release

# Install LV2 bundle
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/RipplerX.lv2
mv ./build/RipplerX_artefacts/Release/LV2/RipplerX.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd ..
rm -rf "ripplerx"

