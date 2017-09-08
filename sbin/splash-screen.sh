#!/bin/bash

# If splash-screen files doesn't exist, generate ...
if [ ! -d $ZYNTHIAN_CONFIG_DIR/img ]; then
	$ZYNTHIAN_SYS_DIR/scripts/generate_fb_splash.sh
fi

# Display Zynthian Boot Splash Screen
if [ -c $FRAMEBUFFER ]; then
	cat $ZYNTHIAN_CONFIG_DIR/img/fb_zynthian_boot.raw > $FRAMEBUFFER
fi  

rm -f $HOME/.remote_display_env
