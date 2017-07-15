#!/bin/sh

export HOME="/root"
export ZYNTHIAN_DIR="/zynthian"
export FRAMEBUFFER="/dev/fb1"

if [ -c $FRAMEBUFFER ]; then
	cat $ZYNTHIAN_DIR/zynthian-ui/img/fb_zynthian_boot.raw > $FRAMEBUFFER
fi  

rm -f $HOME/.remote_display_env
