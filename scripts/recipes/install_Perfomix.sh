#!/bin/bash

PERFOMIX_DIR=PerfomixSrc

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ ! -d "$PERFOMIX_DIR" ]; then
	mkdir "$PERFOMIX_DIR"
fi

# Create directory and fetch heavylib tools and the perfomix (puredata) code
cd $PERFOMIX_DIR
git clone https://github.com/gitnob/pd_to_zynthian_oram.git
git clone https://github.com/gitnob/Perfomix.git

# Install HVCC in th pd_to_zynthian_oram directory
cd pd_to_zynthian_oram

# Install hvcc in the virtual environment of zynthian's python
if [ ! "${VIRTUAL_ENV}" != "$PWD/venv" ] ; then
	echo Please activate virtual python environment of Zynthian in \($VIRTUAL_ENV\) before continue. Stopping script.
	exit 1
fi
pip3 install hvcc
if test ${?} != 0; then
	echo "Installation of HVCC ('pip3 install hvcc') failed."
	exit 3
fi
echo "Heavy compiler environment (HVCC) installed."

# clone heavylib and dpf, as well as dpf-widget repository to lib resp. gen directory
if [ ! -d "./lib/heavylib" ] ; then
	git clone https://github.com/Wasted-Audio/heavylib.git ./lib/heavylib
	if test ${?} != 0; then
		echo "Cloning of hvcc repository failed. Stopping script."
		exit 4
	fi
echo "Heavylib patches (heavylib) for puredata installed."
fi

# Cloning DPF environment into gen/dpf
if [ ! -d "./gen/dpf" ] ; then
	git clone https://github.com/DISTRHO/DPF.git ./gen/dpf
	if test ${?} != 0; then
		echo "Cloning of DPF repository failed. Stopping script."
		exit 4
	fi
fi
echo "Succesfully installed DPF environment."

# Cloning DPF widgets environment into gen/dpf-widgets
if [ ! -d "./gen/dpf-widgets" ] ; then
	git clone https://github.com/DISTRHO/DPF-Widgets.git ./gen/dpf-widgets
	if test ${?} != 0; then
		echo "Cloning of DPF widgets repository failed. Stopping script."
		exit 4
	fi
fi
echo "DPF widgets repositories installed."

echo "Succesfully created development environment."

PDFILE=$ZYNTHIAN_PLUGINS_SRC_DIR/$PERFOMIX_DIR/Perfomix/Perfomix.pd
METAFILE=$ZYNTHIAN_PLUGINS_SRC_DIR/$PERFOMIX_DIR/Perfomix/Perfomix.json
LV_NAME=Perfomix
LV2_URI="lv2://nobisoft.de/Perfomix"		
LV_COPYRIGHT="GPLv3 2024 Gaggenau Nobisoft"
HVLIB=./lib/heavylib/

# generating hvcc files
echo Creating hvcc compiler code with the following command:
echo hvcc "$PDFILE" -o gen -n "$LV_NAME" -p "$HVLIB" -g dpf --copyright "$LV_COPYRIGHT" -m "$METAFILE"
hvcc "$PDFILE" -o gen -n "$LV_NAME" -p "$HVLIB" -g dpf --copyright "$LV_COPYRIGHT" -m "$METAFILE"
if test ${?} != 0; then
	echo "Error generating hvcc code. stopping."
	exit 5
fi

# compiling the C code
cd gen
make
if test ${?} != 0; then
	echo "Error compiling lv2. stopping."
	exit 6
fi

# Copy better ttl parameter file to lv2 directory
cp $ZYNTHIAN_PLUGINS_SRC_DIR/$PERFOMIX_DIR/Perfomix/*.ttl bin/Perfomix.lv2/

cp -r bin/Perfomix.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2/
cp -r $ZYNTHIAN_PLUGINS_SRC_DIR/$PERFOMIX_DIR/Perfomix/Perfomix_Default.preset.lv2 $ZYNTHIAN_MY_DATA_DIR/presets/lv2/


cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf $PERFOMIX_DIR
