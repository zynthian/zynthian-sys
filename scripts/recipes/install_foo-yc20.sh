#!/bin/bash

# Install Faust?
$ZYNTHIAN_RECIPE_DIR/install_faust.sh

# Foo-YC20 combo-organ emulator
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/sampov2/foo-yc20.git
cd foo-yc20
make -j 3
make install
make clean
