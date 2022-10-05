#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Delayed action flags library
# 
# + Manage flags for restarting services and rebooting zynthian
# 
# Copyright (C) 2015-2021 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
# ****************************************************************************

#------------------------------------------------------------------------------
# Set flag master
#------------------------------------------------------------------------------

if [ -z $ZYNTHIAN_FLAG_MASTER ]; then
	export ZYNTHIAN_FLAG_MASTER=$0
fi

#------------------------------------------------------------------------------
# Flag files
#------------------------------------------------------------------------------

export RESTART_UI_FLAGFILE="/tmp/zynthian_restart_ui"
export RESTART_WEBCONF_FLAGFILE="/tmp/zynthian_restart_webconf"
export REBOOT_FLAGFILE="/tmp/zynthian_reboot"

#------------------------------------------------------------------------------
# Management functions
#------------------------------------------------------------------------------

function clean_all_flags() {
	rm -f $REBOOT_FLAGFILE
	rm -f $RESTART_UI_FLAGFILE
	rm -f $RESTART_WEBCONF_FLAGFILE
}

function clean_reboot_flag() {
	rm -f $REBOOT_FLAGFILE
}

function clean_restart_ui_flag() {
	rm -f $RESTART_UI_FLAGFILE
}

function clean_restart_webconf_flag() {
	rm -f $RESTART_WEBCONF_FLAGFILE
}

function set_reboot_flag() {
	touch $REBOOT_FLAGFILE
}

function set_restart_ui_flag() {
	touch $RESTART_UI_FLAGFILE
}

function set_restart_webconf_flag() {
	touch $RESTART_WEBCONF_FLAGFILE
}

function run_flag_actions() {

	if [ "$ZYNTHIAN_FLAG_MASTER" = "$0" ]; then
		echo "Running Flag Actions from '$0'..."

		if [ -f $REBOOT_FLAGFILE ]; then
			clean_all_flags
			echo "Saving state..."
			send_osc 1370 /CUIA/LAST_STATE_ACTION
			sleep 1
			echo "Rebooting..."
			reboot
			return
		fi

		if [ -f $RESTART_UI_FLAGFILE ]; then
			clean_restart_ui_flag
			echo "Saving state..."
			send_osc 1370 /CUIA/LAST_STATE_ACTION
			sleep 1
			echo "Restarting zynthian service..."
			systemctl restart zynthian
		fi

		if [ -f $RESTART_WEBCONF_FLAGFILE ]; then
			clean_restart_webconf_flag
			echo "Restarting zynthian-webconf service..."
			systemctl restart zynthian-webconf
		fi
	fi
}

function show_flag_actions() {
		if [ -f $REBOOT_FLAGFILE ]; then
			echo "REBOOT = ON"
		else
			echo "REBOOT = OFF"
		fi

		if [ -f $RESTART_UI_FLAGFILE ]; then
			echo "RESTART_UI = ON"
		else
			echo "RESTART_UI = OFF"
		fi

		if [ -f $RESTART_WEBCONF_FLAGFILE ]; then
			echo "RESTART_WEBCONF = ON"
		else
			echo "RESTART_WEBCONF = OFF"
		fi
}

function run_reboot_flag_action_raw() {
	if [ -f $REBOOT_FLAGFILE ]; then
		clean_all_flags
		echo "Rebooting..."
		reboot
	fi
}

#------------------------------------------------------------------------------

cmd=${1,,}
opt=${2,,}

if [[ "$cmd" == "set" ]]; then
	if [[ "$opt" == "reboot" ]]; then
		set_reboot_flag
	elif [[ "$opt" == "restart_ui" ]]; then
		set_restart_ui_flag
	elif [[ "$opt" == "restart_webconf" ]]; then
		set_restart_webconf_flag
	else
		echo "Not valid action-flag operation"
	fi
elif [[ "$cmd" == "clean" ]]; then
	if [[ "$opt" == "reboot" ]]; then
		clean_reboot_flag
	elif [[ "$opt" == "restart_ui" ]]; then
		clean_restart_ui_flag
	elif [[ "$opt" == "restart_webconf" ]]; then
		clean_restart_webconf_flag
	elif [[ "$opt" == "all" ]]; then
		clean_all_flags
	else
		echo "Not valid action-flag operation."
	fi
elif [[ "$cmd" == "show" ]]; then
	show_flag_actions
elif [[ "$cmd" != "" ]]; then
	echo "Not valid action-flag command. Use 'set' or 'clean'."
fi

#------------------------------------------------------------------------------
