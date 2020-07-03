#!/bin/bash

cd /usr/lib/arm-linux-gnueabihf/lv2/amsynth.lv2

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

# Needed for loading PNG correctly when using jalv.gtk
update-mime-database /usr/share/mime

