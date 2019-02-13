#!/bin/bash

# Install Kernel 4.18 from HifiBerry (required by DAC+ ADC)

cd $ZYNTHIAN_SW_DIR
git clone https://github.com/hifiberry/dacadckernel
cd /
tar xfvz $ZYNTHIAN_SW_DIR/dacadckernel/4.18.dacadc.tar.gz  --no-same-owner
rm -rf $ZYNTHIAN_SW_DIR/dacadckernel

