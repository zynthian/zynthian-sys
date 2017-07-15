#!/bin/bash

if [ -f "./zynthian_envars.sh" ]; then
	source "./zynthian_envars.sh"
elif [ -z "$ZYNTHIAN_SYS_DIR" ]; then
	source "/zynthian/zynthian-sys/scripts/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

echo "Generating Splash Screens for FrameBuffer ..."

fbi -noverbose -T 2 -a -d $FRAMEBUFFER $ZYNTHIAN_UI_DIR/img/zynthian_logo_error.png
sleep 1
cat $FRAMEBUFFER > $ZYNTHIAN_UI_DIR/img/fb_zynthian_error.raw

fbi -noverbose -T 2 -a -d $FRAMEBUFFER $ZYNTHIAN_UI_DIR/img/zynthian_logo_boot.png
sleep 1
cat $FRAMEBUFFER > $ZYNTHIAN_UI_DIR/img/fb_zynthian_boot.raw

killall -9 fbi
