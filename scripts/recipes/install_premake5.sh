#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ -d "premake-core" ]; then
	rm -rf "premake-core"
fi

git clone https://github.com/premake/premake-core.git
cd premake-core
make -j3 -f Bootstrap.mak linux 
#./bin/release/premake5 gmake
./bin/release/premake5 embed
#./bin/release/premake5 test
cp ./bin/release/premake5 /usr/local/bin/premake5
cd ..

rm -rf "premake-core"
