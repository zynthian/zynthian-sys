#!/bin/sh

export ZYNTHIAN_LOG_LEVEL=10			# 10=DEBUG, 20=INFO, 30=WARNING, 40=ERROR, 50=CRITICAL
export ZYNTHIAN_RAISE_EXCEPTIONS=0
export ZYNTHIAN_DIR="/zynthian"
export FRAMEBUFFER="/dev/fb1"
export HOME="/root"

cd $ZYNTHIAN_DIR/zynthian-ui
startx ./zynthian.sh -- :0 vt3
