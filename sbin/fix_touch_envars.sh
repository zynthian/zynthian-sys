#!/bin/bash

# Fix touch configuration
if [[ "$ZYNTHIAN_WIRING_LAYOUT" == "TOUCH_ONLY" ]]; then
	if grep -q "v5_keypad_right" /zynthian/config/zynthian_envars.sh; then
		set_envar.py ZYNTHIAN_UI_TOUCH_NAVIGATION "v5_keypad_right"
	else
		set_envar.py ZYNTHIAN_UI_TOUCH_NAVIGATION "v5_keypad_left"
	fi
else
	set_envar.py ZYNTHIAN_UI_TOUCH_NAVIGATION ""
fi

# Remove obsolete touch envars
sed -i \
	-e '/^export ZYNTHIAN_UI_TOUCH_WIDGETS=/d' \
	-e '/^export ZYNTHIAN_UI_TOUCH_NAVIGATION2=/d' \
	-e '/^export ZYNTHIAN_TOUCH_KEYPAD_SIDE_LEFT=/d' \
	-e '/^export ZYNTHIAN_UI_ONSCREEN_BUTTONS=/d' \
	/zynthian/config/zynthian_envars.sh
