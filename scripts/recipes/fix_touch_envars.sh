#!/bin/bash

# Script to remove obsolete touch env vars

if [[ "$ZYNTHIAN_WIRING_LAYOUT" != "V5" && "$ZYNTHIAN_WIRING_LAYOUT" != "Z2" ]]; then
	if grep -q "v5_keypad_right" /zynthian/config/zynthian_envars.sh; then
		set_envar.py ZYNTHIAN_UI_TOUCH_NAVIGATION v5_keypad_right
	else
		set_envar.py ZYNTHIAN_UI_TOUCH_NAVIGATION v5_keypad_left
	fi
else
	-e '/^export ZYNTHIAN_UI_TOUCH_NAVIGATION=/d'
fi

sed -i \
	-e '/^export ZYNTHIAN_UI_TOUCH_WIDGETS=/d' \
	-e '/^export ZYNTHIAN_UI_TOUCH_NAVIGATION2=/d' \
	-e '/^export ZYNTHIAN_TOUCH_KEYPAD_SIDE_LEFT=/d' \
	/zynthian/config/zynthian_envars.sh
