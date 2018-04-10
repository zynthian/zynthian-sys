#!/bin/bash

exit
source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"

if [ ! -f "$ZYNTHIAN_CONFIG_DIR/updates/beyond" ]; then

	# Install some extra packages
	apt-get -y update
	apt-get -y install libgtk2.0-dev libgtkmm-2.4-dev liblrdf-dev libboost-system-dev fonts-roboto
	apt-get -y dist-upgrade
	yes | rpi-update

	# 2018-04-09 => Rebuild DISTRHO ports, DFP & guitarix plugins
	if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/DISTRHO-Ports" ]; then
		bash $ZYNTHIAN_RECIPE_DIR/install_distrho_ports.sh
	fi
	if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/DFP-Plugins" ]; then
		bash $ZYNTHIAN_RECIPE_DIR/install_dfp_plugins.sh
	fi
	if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/guitarix-0.36.1" ]; then
		rm -rf $ZYNTHIAN_SW_DIR/plugins/guitarix-git
		bash $ZYNTHIAN_RECIPE_DIR/install_guitarix.sh
	fi

	# Create flag for beyond update
	if [ ! -d "$ZYNTHIAN_CONFIG_DIR/updates" ]; then
		mkdir "$ZYNTHIAN_CONFIG_DIR/updates"
	fi
	touch "$ZYNTHIAN_CONFIG_DIR/updates/beyond"

	# Force Reboot
	touch $REBOOT_FLAGFILE
fi
