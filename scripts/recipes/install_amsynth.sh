#!/bin/bash

# amsynth
cd $ZYNTHIAN_SW_DIR

version="1.9.0"

rm -rf amsynth-*
wget https://github.com/amsynth/amsynth/releases/download/release-1.9.0/amsynth-$version.tar.bz2
tar xfvj amsynth-$version.tar.bz2
rm -f amsynth-$version.tar.bz2

cd amsynth-$version

# Fix LV2 bundle
cd ./data/amsynth.lv2
# Fix banks
sed -i 's#a pset:Bank ;#a pset:bank ;\n    lv2:appliesTo <http://code.google.com/p/amsynth/amsynth> ;#g' amsynth.ttl
# Shorter Preset Names
for bfile in *.bank.ttl; do
	OIFS=$IFS; IFS='.'
	read -ra parts <<< "$bfile"
	IFS=$OIFS
	toremove="${parts[0]}: "
	sed -i "s#$toremove##g" $bfile
	sed -i "s#$toremove##g" amsynth.ttl
done
cd ../..

./configure
make -j 3
make install
cd ..

if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2" ]; then
	rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2"
fi
ln -s "/usr/local/lib/lv2/amsynth.lv2" "$ZYNTHIAN_PLUGINS_DIR/lv2"
