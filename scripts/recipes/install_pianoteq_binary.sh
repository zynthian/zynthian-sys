#!/bin/bash

# This script is designed to work with the different
# versions of Pianoteq binary packages. It tries to be
# as general as possible, not relying on fixed dir/filenames.
# It should work with Stage,Standard and Pro versions 6.X and
# i hope 7.X too, when available ;-)

pack_fpath=$1

cd $ZYNTHIAN_SW_DIR

# Save current version, deleting the older one
if [ -f pianoteq/pianoteq ]; then
	rm -rf pianoteq.old
	mv pianoteq pianoteq.old
else
	rm -rf pianoteq
fi

if [ ${MACHINE_HW_NAME} = "armv7l" ]; then
	armdir="arm-32bit"
elif [ ${MACHINE_HW_NAME} = "aarch64" ]; then
	armdir="arm-64bit"
fi

# Uncompress new binary package and delete unused files
7z x "$pack_fpath" \*/$armdir \*/Documentation \*/README_LINUX.txt \*/Licence.rtf
mv Pianoteq* pianoteq

# Create symlink to binary
cd pianoteq
ln -s ./$armdir/Pianoteq* .
rm -f *.lv2
rm -f *.so
mv Pianoteq* pianoteq

# Delete old LV2 plugin
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Pianoteq*.lv2

# Check installation result:
if [ -L "$ZYNTHIAN_SW_DIR/pianoteq/pianoteq" ]; then
	echo "Pianoteq Installed Successfully!"
else
	echo "Pianoteq Installation Failed!"
fi

exit

#----------------------------------------------------------
# Don't install Pianoteq LV2 to avoid confusion
#----------------------------------------------------------

# Create symlink to LV2 plugin directory.
ln -s $ZYNTHIAN_SW_DIR/pianoteq/$armdir/*.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

# Generate LV2 presets (Pianoteq >= v7.2.1)
if [[ "$VIRTUALIZATION" == "none" ]]; then
	version=$(./pianoteq --version | cut -d' ' -f4)
	if [[ $version > "7.2.0" ]]; then
		rm -rf $ZYNTHIAN_MY_DATA_DIR/presets/lv2/"Pianoteq 7 "*"-factory-presets"*.lv2
		./pianoteq --export-lv2-presets $ZYNTHIAN_MY_DATA_DIR/presets/lv2
	fi
fi

#----------------------------------------------------------