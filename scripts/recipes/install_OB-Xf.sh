#!/bin/bash

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit

if [ -d "OB-Xf" ]; then
	rm -rf "OB-Xf"
fi

git clone https://github.com/surge-synthesizer/OB-Xf.git
cd OB-Xf || exit
git submodule update --init --recursive
sed -i "s/VST3 Standalone//" CMakeLists.txt
cmake -B Builds/Release -DCMAKE_BUILD_TYPE=Release .
cmake --build Builds/Release --config Release --target obxf-staged -j 3

rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/OB-Xf.lv2"
mv ./Builds/Release/OB-Xf_artefacts/Release/LV2/OB-Xf.lv2 "$ZYNTHIAN_PLUGINS_DIR/lv2"

# Remove old wrong assets folder
assets_dir="/root/Documents/Surge Synth Team/OB-Xf"
if [ -d "$assets_dir" ]; then
	rm -rf "$assets_dir"
fi
# Create system assets dir
assets_dir="/usr/local/share/Surge Synth Team/OB-Xf"
if [ -d "$assets_dir" ]; then
	rm -rf "$assets_dir/Themes"
	rm -rf "$assets_dir/Patches"
else
	mkdir -p "$assets_dir"
fi
mv assets/installer/Surge\ Synth\ Team/OB-Xf/* "$assets_dir"

cd .. || exit
rm -rf OB-Xf
