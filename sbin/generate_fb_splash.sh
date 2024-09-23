#!/bin/bash

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"

#------------------------------------------------------------------------------

# Create directory if it doesn't exist
if [ ! -d "$ZYNTHIAN_CONFIG_DIR/img" ]; then
	mkdir $ZYNTHIAN_CONFIG_DIR/img
fi

# Find display resolution if needed
if [[ "${DISPLAY_WIDTH}" == "" || "${DISPLAY_HEIGHT}" == "" ]]; then
	if [[ "$DISPLAY" != "" ]]; then
		geometry=($(xrandr | grep -oP '(?<= connected | primary )[x\d]+' | awk -F'[x]' '{print "geometry " $1 " " $2}'))
	else
		geometry=($(fbset -s | grep geometry))
	fi
	DISPLAY_WIDTH=${geometry[1]}
	DISPLAY_HEIGHT=${geometry[2]}
fi

echo "Generating splash images for display resolution $DISPLAY_WIDTH x $DISPLAY_HEIGHT..."

convert_options="-resize ${DISPLAY_WIDTH}x -gravity Center -extent ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT} -strip" 
/usr/bin/convert "$ZYNTHIAN_UI_DIR/img/zynthian_logo_boot.jpg" $convert_options "$ZYNTHIAN_CONFIG_DIR/img/fb_zynthian_boot.jpg"
/usr/bin/convert "$ZYNTHIAN_UI_DIR/img/zynthian_logo_error.jpg" $convert_options "$ZYNTHIAN_CONFIG_DIR/img/fb_zynthian_error.jpg"
