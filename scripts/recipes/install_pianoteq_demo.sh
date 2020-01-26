#!/bin/bash

export PIANOTEQ_INSTALL_FILENAME="pianoteq_stage_linux_trial_v660.7z"

cd $ZYNTHIAN_SW_DIR
wget http://zynthian.org/download/$PIANOTEQ_INSTALL_FILENAME
$ZYNTHIAN_RECIPE_DIR/install_pianoteq_binary.sh "$ZYNTHIAN_SW_DIR/$PIANOTEQ_INSTALL_FILENAME"
rm -f "$ZYNTHIAN_SW_DIR/$PIANOTEQ_INSTALL_FILENAME"

$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh
