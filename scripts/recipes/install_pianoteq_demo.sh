#!/bin/bash

cd $ZYNTHIAN_SW_DIR
wget http://zynthian.org/download/pianoteq_stage_linux_trial_v651.7z
$ZYNTHIAN_RECIPE_DIR/install_pianoteq_binary.sh "$ZYNTHIAN_SW_DIR/pianoteq_stage_linux_trial_v651.7z"
rm -f "$ZYNTHIAN_SW_DIR/pianoteq_stage_linux_trial_v651.7z"

$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh
