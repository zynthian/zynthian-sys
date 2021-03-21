#!/bin/bash

# Jamulus
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/jamulussoftware/jamulus.git --branch r3_7_0 jamulus
cd jamulus

qmake  Jamulus.pro
make all
make install
make clean
