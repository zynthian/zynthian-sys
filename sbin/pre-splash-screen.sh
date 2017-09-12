#!/bin/bash

# Delete Remote Display Environment from previous boot
rm -f $HOME/.remote_display_env

# If splash-screen files doesn't exist, generate ...
if [ ! -d $ZYNTHIAN_CONFIG_DIR/img ]; then
	$ZYNTHIAN_SYS_DIR/sbin/generate_fb_splash.sh
fi

