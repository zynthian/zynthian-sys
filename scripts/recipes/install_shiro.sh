#!/bin/bash

# install_shiro.sh

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "SHIRO-Plugins" ]; then
	rm -rf "SHIRO-Plugins"
fi

# git clone --recursive https://github.com/ninodewit/SHIRO-Plugins.git
git clone --recursive https://github.com/BlokasLabs/SHIRO-Plugins.git
cd SHIRO-Plugins

sed -i -- 's/-march=armv6 //' Makefile.mk
sed -i -- 's/\$(MAKE) all -C plugins\/larynx//' Makefile
sed -i -- 's/\$(MAKE) all -C plugins\/harmless//' Makefile
sed -i -- 's/set \-e/#set \-e/' ./dpf/utils/generate-ttl.sh

rm -rf "./data/Larynx.lv2"
rm -rf "./data/Harmless.lv2"
rm -rf "./bin/Larynx.lv2"
rm -rf "./bin/Harmless.lv2"

export RASPPI=true
make -j 3 all
cp -r bin/*.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2/

cd ..

rm -rf SHIRO-Plugins
