#!/bin/bash

# preset2lv2: convert native presets to LV2
cd $ZYNTHIAN_SW_DIR
git clone https://gitlab.com/Jofemodo/preset2lv2
cd preset2lv2
python3 ./setup.py install
cd ..
