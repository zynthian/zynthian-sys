#!/bin/bash

arg1="$1"
set --

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------

echo "Regenerating LV2 presets DB: $arg1 ..."

# Run engine-specific generation scripts
if [ "$arg1" == "http://github.com/nicklan/drmr" ]; then
	generate_lv2_presets_DrMr.py
elif [ "$arg1" == "https://tal-software.com/TAL-U-NO-LX-V2" ]; then
	generate_lv2_presets_TAL-U-NO-LX.py
fi

# Regenerate zynthian presets cache (jalv)
cd $ZYNTHIAN_UI_DIR/zyngine
./zynthian_lv2.py presets $arg1

# If cache is regenerated from scratch, restart zynthian services
if [ "$arg1" == "" ]; then
	set_restart_ui_flag
	set_restart_webconf_flag
fi
run_flag_actions

