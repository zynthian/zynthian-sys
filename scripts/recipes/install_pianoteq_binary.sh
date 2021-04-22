#!/bin/bash

# This script is designed to work with the different
# versions of Pianoteq binary packages. It tries to be
# as general as possible, not relying on fixed dir/filenames.
# It should work with Stage,Standard and Pro versions 6.X and
# i hope 7.X too, when available ;-)

pack_fpath=$1

cd $ZYNTHIAN_SW_DIR

# Save current binary, deleting the older one
if [ -f pianoteq6/pianoteq ]; then 
	rm -rf pianoteq6.old
	mv pianoteq6 pianoteq6.old
else
	rm -rf pianoteq6
fi

# Uncompress new binary package and delete unused files
7z x "$pack_fpath" \*/arm-32bit \*/arm  \*/Documentation \*/README_LINUX.txt \*/Licence.rtf
mv Pianoteq* pianoteq6

# Create symlink to binary
cd pianoteq6
if [ -d arm ]; then
	armdir="arm"
else
	armdir="arm-32bit"
fi

ln -s ./$armdir/Pianoteq* .
rm -f *.lv2
rm -f *.so
mv Pianoteq* pianoteq

# Delete old LV2 plugin
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Pianoteq*.lv2

# Create symlink to LV2 plugin directory.
ln -s $ZYNTHIAN_SW_DIR/pianoteq6/$armdir/*.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

# Generate LV2 presets (Pianoteq >= v7.2.1)
version=$(./pianoteq --version | cut -d' ' -f4)
if [[ $version > "7.2.0" ]]; then
	rm -rf $ZYNTHIAN_MY_DATA_DIR/presets/lv2/"Pianoteq 7 "*"-factory-presets"*.lv2
	./pianoteq --export-lv2-presets $ZYNTHIAN_MY_DATA_DIR/presets/lv2
fi
