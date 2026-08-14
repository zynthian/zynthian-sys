#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"

export PYTHONFAULTHANDLER=1
export ZYNTHIAN_LOG_LEVEL=10			# 10=DEBUG, 20=INFO, 30=WARNING, 40=ERROR, 50=CRITICAL

if [[ "$1" == "wayland" ]]; then
	export ZYNTHIAN_UI_WAYLAND="1"
fi

cd $ZYNTHIAN_UI_DIR

if [[ "$ZYNTHIAN_UI_WAYLAND" == "1" ]]; then
	export PYOPENGL_PLATFORM=x11
	labwc -S ./zynthian.sh
else
	if [ "$ZYNTHIAN_UI_ENABLE_CURSOR" == "1" ]; then
		X11_SERVER_OPTIONS=""
	else
		X11_SERVER_OPTIONS="-nocursor"
	fi
	startx ./zynthian.sh -- -r -s 0 $X11_SERVER_OPTIONS
	#startx ./zynthian.sh -- :0 vt3
fi
