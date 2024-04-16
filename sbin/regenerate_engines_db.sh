#!/bin/bash

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------

arg1="$1"
if [ "$arg1" == "" ]; then
	arg1="all"
fi

echo "Regenerating engines DB: $arg1 ..."
cd $ZYNTHIAN_UI_DIR/zyngine
./zynthian_lv2.py $arg1

set_restart_ui_flag
set_restart_webconf_flag

run_flag_actions

