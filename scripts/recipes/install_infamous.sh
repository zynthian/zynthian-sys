#!/bin/bash

# infamous

export CXXFLAGS="$CFLAGS -fpermissive"

cd $ZYNTHIAN_SW_DIR/plugins
if [ -d "infamousPlugins" ]; then
	rm -rf "infamousPlugins"
fi

git clone https://github.com/ssj71/infamousPlugins.git
cd infamousPlugins
mkdir build
cd build
cmake -DLIBDIR="" -DCMAKE_INSTALL_PREFIX=${ZYNTHIAN_PLUGINS_DIR} ..
for i in `find src -name cmake_install.cmake`; do
	sed -i -- "s/lib\/lv2/lv2/" $i
done
make -j 4
make install
mv /zynthian/zynthian-plugins/bin/infamous-rule /usr/local/bin
make clean
cd ..

rm -rf "infamousPlugins"
