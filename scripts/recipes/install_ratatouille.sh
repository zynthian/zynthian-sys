#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

# DSP plugin

if [-d "neural-amp-modeler-lv2"]; then
  rm -rf "neural-amp-modeler-lv2"
fi

git clone --recursive https://github.com/brummer10/Ratatouille.lv2.git
cd Ratatouille.lv2
make -j 3
make install

cd ..
rm -rf "Ratatouille.lv2"
