#!/bin/bash

arg1="$1"
if [ "$arg1" == "" ]; then
	arg1="engines"
fi
set --

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------


echo "Regenerating engines DB: $arg1 ..."
cd $ZYNTHIAN_UI_DIR/zyngine
./zynthian_lv2.py $arg1

if [ "$arg1" == "all" ]; then
	set_restart_ui_flag
	set_restart_webconf_flag
fi

run_flag_actions

