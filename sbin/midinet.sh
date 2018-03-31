#!/bin/bash

export ZYNTHIAN_LOG_LEVEL=10			# 10=DEBUG, 20=INFO, 30=WARNING, 40=ERROR, 50=CRITICAL
export ZYNTHIAN_RAISE_EXCEPTIONS=0

cd $ZYNTHIAN_UI_DIR
/usr/local/bin/qmidinet --no-gui --jack-midi=1 --alsa-midi=0 -n=4
