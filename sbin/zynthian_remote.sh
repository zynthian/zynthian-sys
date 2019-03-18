#!/bin/bash

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

export ZYNTHIAN_LOG_LEVEL=10			# 10=DEBUG, 20=INFO, 30=WARNING, 40=ERROR, 50=CRITICAL
export ZYNTHIAN_RAISE_EXCEPTIONS=0
export ZYNTHIAN_UI_ENABLE_CURSOR=1
export ZYNTHIAN_UI_FONT_SIZE=14
export DISPLAY_WIDTH=480
export DISPLAY_HEIGHT=320

cd $ZYNTHIAN_UI_DIR
./zynthian_gui.py
