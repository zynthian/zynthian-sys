#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"

if [ -z "$ZYNTHIAN_CONFIG_DIR" ]; then
	# Fix config file
	sed -i -e "s/export ZYNTHIAN_DIR=\"\/zynthian\"/export ZYNTHIAN_DIR=\"\/zynthian\"\nexport ZYNTHIAN_CONFIG_DIR=\"\$ZYNTHIAN_DIR\/config\"/g" $ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh

	# Fix environment loading at startup
	sed -i -e "s/zynthian-sys\/scripts/config/g" /root/.bashrc

	# Reboot
	touch $REBOOT_FLAGFILE
fi
