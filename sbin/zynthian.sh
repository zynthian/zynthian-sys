#!/bin/bash

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

export ZYNTHIAN_LOG_LEVEL=10			# 10=DEBUG, 20=INFO, 30=WARNING, 40=ERROR, 50=CRITICAL
export ZYNTHIAN_RAISE_EXCEPTIONS=1

cd $ZYNTHIAN_UI_DIR
startx ./zynthian.sh -- :0 vt3
