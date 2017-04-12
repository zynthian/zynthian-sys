#!/bin/sh

source "/zynthian/zynthian-sys/scripts/zynthian_envars.sh"

export ZYNTHIAN_LOG_LEVEL=10			# 10=DEBUG, 20=INFO, 30=WARNING, 40=ERROR, 50=CRITICAL
export ZYNTHIAN_RAISE_EXCEPTIONS=0

cd $ZYNTHIAN_DIR/zynthian-ui
startx ./zynthian.sh -- :0 vt3
