#!/bin/bash

# amsynth
cd $ZYNTHIAN_SW_DIR

version="1.13.2"

rm -rf amsynth-*
wget https://github.com/amsynth/amsynth/releases/download/release-$version/amsynth-$version.tar.gz
tar xfvz amsynth-$version.tar.gz
rm -f amsynth-$version.tar.gz

cd amsynth-$version

# Fix LV2 bundle
cd ./data/amsynth.lv2

# Fix banks
sed -i "s#a pset:Bank ;#a pset:Bank ;\n    lv2:appliesTo <http://code.google.com/p/amsynth/amsynth> ;#g" amsynth.ttl

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
make -j 2 2>/dev/null
make install
cd ..

# Needed for loading PNG correctly when using jalv.gtk
update-mime-database /usr/share/mime


if [ -e "$ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2" ]; then
	rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2"
fi
