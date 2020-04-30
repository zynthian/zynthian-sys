#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/premake/premake-core.git
cd premake-core
make -j3 -f Bootstrap.mak linux 
#premake5 gmake
premake5 embed
#bin/release/premake5 test
cp bin/release/premake5 /usr/local/bin/premake5
cd ..
