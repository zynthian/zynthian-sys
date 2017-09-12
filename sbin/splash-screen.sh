#!/bin/bash

# Display Zynthian Boot Splash Screen
if [ -c $FRAMEBUFFER ]; then
	cat $ZYNTHIAN_CONFIG_DIR/img/fb_zynthian_boot.raw > $FRAMEBUFFER
fi  
