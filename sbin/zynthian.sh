#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"

export PYTHONFAULTHANDLER=1
export ZYNTHIAN_LOG_LEVEL=10			# 10=DEBUG, 20=INFO, 30=WARNING, 40=ERROR, 50=CRITICAL

cd $ZYNTHIAN_UI_DIR
startx ./zynthian.sh
#startx ./zynthian.sh -- :0 vt3
