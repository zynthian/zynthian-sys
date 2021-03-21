#!/bin/bash

# Jamulus
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/corrados/jamulus.git --branch r3_6_2 jamulus
cd jamulus

qmake  Jamulus.pro
make all
make install
make clean
