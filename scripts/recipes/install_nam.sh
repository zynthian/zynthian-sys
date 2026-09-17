#!/bin/bash

nam_lv2_path="$ZYNTHIAN_PLUGINS_DIR/lv2/Neural_Amp_Modeler.lv2"

cd $ZYNTHIAN_PLUGINS_SRC_DIR

# DSP plugin

if [-d "neural-amp-modeler-lv2"]; then
  rm -rf "neural-amp-modeler-lv2"
fi

git clone --recurse-submodules -j4 https://github.com/mikeoliphant/neural-amp-modeler-lv2
cd neural-amp-modeler-lv2/build
cmake .. -DCMAKE_BUILD_TYPE="Release" 
make -j4

mv ./neural_amp_modeler.lv2 $nam_lv2_path

cd ..
rm -rf "neural-amp-modeler-lv2"

# UI plugin

if [-d "neural-amp-modeler-ui"]; then
  rm -rf "neural-amp-modeler-ui"
fi

git clone --recurse-submodules https://github.com/brummer10/neural-amp-modeler-ui.git
cd neural-amp-modeler-ui
make -j 4
mv $nam_lv2_path/manifest.ttl $nam_lv2_path/manifest_dsp.ttl
mv ./bin/Neural_Amp_Modeler_ui.lv2/* $nam_lv2_path

cd ..
rm -rf "neural-amp-modeler-ui"


