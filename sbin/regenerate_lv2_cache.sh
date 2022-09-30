#!/bin/bash

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

echo "Regenerating cache LV2..."
cd $ZYNTHIAN_UI_DIR/zyngine
python3 ./zynthian_lv2.py

set_restart_ui_flag
set_restart_webconf_flag

run_flag_actions

