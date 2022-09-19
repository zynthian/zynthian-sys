#!/bin/bash

exit

# Display Zynthian Boot Splash Screen => Not used anymore!
if [[ "$FRAMEBUFFER" == "/dev/fb1" ]]; then
	cat $ZYNTHIAN_CONFIG_DIR/img/fb_zynthian_boot.raw > $FRAMEBUFFER
fi  
