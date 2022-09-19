#!/bin/bash

# Display Zynthian Boot Splash Screen
if [[ "$FRAMEBUFFER" == "/dev/fb1" ]]; then
	cat $ZYNTHIAN_CONFIG_DIR/img/fb_zynthian_boot.raw > $FRAMEBUFFER
fi  
