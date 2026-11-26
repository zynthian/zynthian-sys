#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Service control during software update
#
# + Stop non-essential services to free RAM before updating (low-memory devices)
# + Restore the stopped services after the update, even if it failed
# + Show update progress on the display (plymouth) while the UI is stopped
#
# Usage:
#   update_zynthian_services.sh stop              Stop the non-essential services
#   update_zynthian_services.sh restore           Restart the stopped services
#   update_zynthian_services.sh progress <text>   Show a progress message
#   update_zynthian_services.sh low_mem           Exit 0 if RAM is below threshold
#
# "restore" is run by the zynthian-update unit's ExecStopPost, so it also runs
# when the update is killed or crashes.
#
# Copyright (C) 2015-2026 Fernando Moyano <jofemodo@zynthian.org>
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

UPDATE_STATE_DIR="/run/zynthian_update"
STOPPED_SERVICES_FILE="$UPDATE_STATE_DIR/stopped_services"
PLYMOUTH_FLAG_FILE="$UPDATE_STATE_DIR/plymouth"
RESULT_FILE="$UPDATE_STATE_DIR/result"
RESTART_WEBCONF_FILE="$UPDATE_STATE_DIR/restart_webconf"
UPDATE_LOG="/tmp/zynthian_update.log"

# Services are stopped only if total RAM is below this (MiB). A "2GB" board
# reports ~1.8-1.9GiB of MemTotal, so the default treats 2GB boards as "not low".
LOW_MEM_THRESHOLD_MB=${ZYNTHIAN_UPDATE_LOW_MEM_MB:-1792}

# Non-essential services in START order. They are stopped in reverse order.
# Not stopped: networking, ssh, avahi, usb-gadget (network over USB),
# zynthian-pwm-fan (cooling), backlight and cpu-performance.
# zynthian-webconf is stopped unless it launched the update.
NON_ESSENTIAL_SERVICES=(
	jack2
	a2jmidid
	mod-ttymidi
	bluetooth
	jack2whip
	jack-midi-clock
	jacknetumpd
	jackrtpmidid
	qmidinet
	touchosc2midi
	aubionotes
	mediamtx
	headphones
	mod-host
	mod-sdk
	mod-ui
	browsepy
	filebrowser
	vncserver0
	vncserver1
	novnc0
	novnc1
	zynthian
	zynthian_debug
	virtual_zynthian
	zynthian-webconf
)

#------------------------------------------------------------------------------

function total_mem_mb() {
	awk '/^MemTotal:/ {print int($2 / 1024)}' /proc/meminfo
}

function available_mem_mb() {
	awk '/^MemAvailable:/ {print int($2 / 1024)}' /proc/meminfo
}

function is_low_mem() {
	# ZYNTHIAN_UPDATE_STOP_SERVICES=1/0 forces the decision
	if [[ "$ZYNTHIAN_UPDATE_STOP_SERVICES" == "1" ]]; then
		return 0
	elif [[ "$ZYNTHIAN_UPDATE_STOP_SERVICES" == "0" ]]; then
		return 1
	fi
	[[ $(total_mem_mb) -lt $LOW_MEM_THRESHOLD_MB ]]
}

function send_osc_cmd() {
	if [[ -x "/zynthian/venv/bin/send_osc" ]]; then
		/zynthian/venv/bin/send_osc "$@"
	else
		send_osc "$@"
	fi
}

#------------------------------------------------------------------------------
# Progress on the display (best effort: needs plymouth and a theme that shows messages)
#------------------------------------------------------------------------------

function start_plymouth() {
	command -v plymouthd > /dev/null || return
	[[ "$VIRTUALIZATION" == "none" || -z "$VIRTUALIZATION" ]] || return
	if ! plymouth --ping 2> /dev/null; then
		plymouthd --mode=updates 2> /dev/null || plymouthd --mode=boot 2> /dev/null || return
	fi
	plymouth show-splash 2> /dev/null
	touch "$PLYMOUTH_FLAG_FILE"
}

function quit_plymouth() {
	if [[ -f "$PLYMOUTH_FLAG_FILE" ]]; then
		rm -f "$PLYMOUTH_FLAG_FILE"
		# Keep the last frame on screen until the UI draws
		plymouth quit --retain-splash 2> /dev/null
	fi
}

function show_progress() {
	echo -e "\n>>> $*\n"
	if [[ -f "$PLYMOUTH_FLAG_FILE" ]]; then
		plymouth display-message --text="$*" 2> /dev/null
	fi
}

#------------------------------------------------------------------------------
# Stop / restore
#------------------------------------------------------------------------------

function stop_services() {
	local keep_webconf=$ZYNTHIAN_UPDATE_KEEP_WEBCONF
	local active=() svc i

	mkdir -p "$UPDATE_STATE_DIR"

	echo "RAM: $(total_mem_mb)MB total, $(available_mem_mb)MB available. Stopping non-essential services during update..."

	for svc in "${NON_ESSENTIAL_SERVICES[@]}"; do
		if [[ "$svc" == "zynthian-webconf" && "$keep_webconf" == "1" ]]; then
			echo "Keeping zynthian-webconf running (it launched the update)."
			continue
		fi
		if systemctl -q is-active "$svc" 2> /dev/null; then
			active+=("$svc")
		fi
	done

	# Record before stopping, so a failure while stopping still restores everything
	printf "%s\n" "${active[@]}" > "$STOPPED_SERVICES_FILE"

	# Save the UI state before stopping it
	if [[ " ${active[*]} " =~ " zynthian " || " ${active[*]} " =~ " zynthian_debug " || " ${active[*]} " =~ " virtual_zynthian " ]]; then
		echo "Saving UI state..."
		send_osc_cmd 1370 /CUIA/LAST_STATE_ACTION > /dev/null 2>&1
		sleep 1
	fi

	for (( i=${#active[@]}-1; i>=0; i-- )); do
		svc=${active[$i]}
		echo "Stopping $svc..."
		timeout 60 systemctl stop "$svc" || echo "WARNING: Failed to stop $svc"
		# The UI is gone: show progress on the display from now on
		if [[ "$svc" == "zynthian" || "$svc" == "zynthian_debug" ]]; then
			start_plymouth
		fi
	done

	sync
	echo "RAM available after stopping services: $(available_mem_mb)MB"
}

function restore_services() {
	local svc started=0 webconf_started=0

	if [[ ! -f "$RESULT_FILE" ]]; then
		# The update didn't finish: killed, crashed or out of memory
		# EXIT_CODE / EXIT_STATUS / SERVICE_RESULT are set by systemd for ExecStopPost
		echo "WARNING: The update did not complete (${SERVICE_RESULT:-unknown}: ${EXIT_CODE:-?} ${EXIT_STATUS:-?})."
		echo "WARNING: Run the update again to complete it. Log: $UPDATE_LOG"
		show_progress "Update did not complete! Restarting..."
		sleep 5
	fi

	if [[ -f "$STOPPED_SERVICES_FILE" ]]; then
		show_progress "Restarting services..."
		while read -r svc; do
			[[ -z "$svc" ]] && continue
			if [[ "$svc" == "zynthian" || "$svc" == "zynthian_debug" || "$svc" == "virtual_zynthian" ]]; then
				# Release the display for the UI
				quit_plymouth
			fi
			echo "Starting $svc..."
			timeout 60 systemctl start "$svc" || echo "WARNING: Failed to start $svc"
			[[ "$svc" == "zynthian-webconf" ]] && webconf_started=1
			started=1
		done < "$STOPPED_SERVICES_FILE"
		rm -f "$STOPPED_SERVICES_FILE"
	fi
	quit_plymouth

	[[ "$started" == "1" ]] && echo "Services restarted."

	case "$(cat "$RESULT_FILE" 2> /dev/null)" in
		0)
			echo "Update Complete."
			;;
		[1-9]*)
			echo "Update Complete (with warnings)."
			;;
	esac
	# End of log marker for the update launcher
	echo "EOUPDATE"

	# A webconf kept running is restarted last: it is probably showing this log
	if [[ -f "$RESTART_WEBCONF_FILE" ]]; then
		rm -f "$RESTART_WEBCONF_FILE"
		if [[ "$webconf_started" == "0" ]] && systemctl -q is-active zynthian-webconf; then
			sleep 2
			systemctl restart zynthian-webconf
		fi
	fi
}

#------------------------------------------------------------------------------

case "$1" in
	stop)
		stop_services
		;;
	restore)
		restore_services
		;;
	progress)
		shift
		show_progress "$@"
		;;
	low_mem)
		is_low_mem
		;;
	*)
		echo "Usage: $0 stop|restore|progress <text>|low_mem"
		exit 1
		;;
esac
