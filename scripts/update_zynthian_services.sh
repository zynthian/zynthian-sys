#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Service control during software update
#
# + Stop non-essential services to free RAM before updating (low-memory devices)
# + Restore the stopped services after the update, even if it failed
# + Show update progress on the display while the UI is not running
#
# Usage:
#   update_zynthian_services.sh stop              Stop the non-essential services
#   update_zynthian_services.sh restore           Restart the stopped services
#   update_zynthian_services.sh progress <text>   Show a progress message
#   update_zynthian_services.sh display           Show progress on the display if the UI isn't running
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
PROGRESS_PID_FILE="$UPDATE_STATE_DIR/progress.pid"
RESULT_FILE="$UPDATE_STATE_DIR/result"
RESTART_WEBCONF_FILE="$UPDATE_STATE_DIR/restart_webconf"
RUNNING_FILE="$UPDATE_STATE_DIR/running"
STEP_TIME_FILE="$UPDATE_STATE_DIR/step_time"
UPDATE_LOG="/tmp/zynthian_update.log"

# Services are stopped only if total RAM is below this (MiB). A "2GB" board
# reports ~1.8-1.9GiB of MemTotal, so the default treats 2GB boards as "not low".
LOW_MEM_THRESHOLD_MB=${ZYNTHIAN_UPDATE_LOW_MEM_MB:-1792}

# Non-essential services in START order. They are stopped in reverse order.
# Not stopped: networking, ssh, avahi, usb-gadget (network over USB),
# zynthian-pwm-fan (cooling), backlight, cpu-performance and zynthian-webconf
# (it may be showing the update, and it is needed to recover from problems).
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
)

UI_SERVICES=(zynthian zynthian_debug virtual_zynthian)

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

function ui_running() {
	local svc
	for svc in "${UI_SERVICES[@]}"; do
		systemctl -q is-active "$svc" 2> /dev/null && return 0
	done
	return 1
}

function send_osc_cmd() {
	if [[ -x "/zynthian/venv/bin/send_osc" ]]; then
		/zynthian/venv/bin/send_osc "$@"
	else
		send_osc "$@"
	fi
}

#------------------------------------------------------------------------------
# Progress on the display. While the UI runs, it shows the progress screen itself
# (it watches $RUNNING_FILE). Otherwise zynthian_update_progress.py draws the same
# screen on the framebuffer, following the update log.
# Started within the update unit, so systemd kills it when the update ends.
#------------------------------------------------------------------------------

function set_cursor_blink() {
	local f="/sys/class/graphics/fbcon/cursor_blink"
	[[ -w "$f" ]] && echo "$1" > "$f"
}

function start_progress_display() {
	local python="python3" script="$ZYNTHIAN_SYS_DIR/sbin/zynthian_update_progress.py"
	[[ -x "/zynthian/venv/bin/python3" ]] && python="/zynthian/venv/bin/python3"
	[[ -f "$script" ]] || return
	[[ "$VIRTUALIZATION" == "none" || -z "$VIRTUALIZATION" ]] || return
	[[ -e "${FRAMEBUFFER:-/dev/fb0}" ]] || return
	stop_progress_display
	# Stop the console cursor blinking over the progress screen
	set_cursor_blink 0
	"$python" "$script" --log "$UPDATE_LOG" > /dev/null 2>> "$UPDATE_STATE_DIR/progress.err" &
	echo $! > "$PROGRESS_PID_FILE"
}

function stop_progress_display() {
	local pid
	if [[ -f "$PROGRESS_PID_FILE" ]]; then
		pid=$(cat "$PROGRESS_PID_FILE")
		rm -f "$PROGRESS_PID_FILE"
		if [[ -n "$pid" ]] && kill "$pid" 2> /dev/null; then
			# Wait for it to exit before the UI takes the display
			for _ in 1 2 3 4 5 6 7 8 9 10; do
				kill -0 "$pid" 2> /dev/null || break
				sleep 0.2
			done
		fi
	fi
	set_cursor_blink 1
}

function show_progress() {
	date +%s > "$STEP_TIME_FILE" 2> /dev/null
	echo -e "\n>>> $*\n"
}

#------------------------------------------------------------------------------
# Stop / restore
#------------------------------------------------------------------------------

function stop_services() {
	local active=() svc i

	mkdir -p "$UPDATE_STATE_DIR"

	echo "RAM: $(total_mem_mb)MB total, $(available_mem_mb)MB available. Stopping non-essential services during update..."

	for svc in "${NON_ESSENTIAL_SERVICES[@]}"; do
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
		if [[ " ${UI_SERVICES[*]} " =~ " $svc " ]]; then
			start_progress_display
		fi
	done

	sync
	echo "RAM available after stopping services: $(available_mem_mb)MB"
}

function restore_services() {
	local svc started=0

	# The update unit's processes (progress display included) were killed when the
	# update ended: show progress again until the UI is restarted
	if ! ui_running; then
		start_progress_display
	fi

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
			if [[ " ${UI_SERVICES[*]} " =~ " $svc " ]]; then
				# Release the display for the UI
				stop_progress_display
			fi
			echo "Starting $svc..."
			timeout 60 systemctl start "$svc" || echo "WARNING: Failed to start $svc"
			started=1
		done < "$STOPPED_SERVICES_FILE"
		rm -f "$STOPPED_SERVICES_FILE"
	fi
	stop_progress_display

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
	sleep 1
	rm -f "$RUNNING_FILE"

	# Webconf is restarted last: it is probably showing this log
	if [[ -f "$RESTART_WEBCONF_FILE" ]]; then
		rm -f "$RESTART_WEBCONF_FILE"
		if systemctl -q is-active zynthian-webconf; then
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
	display)
		ui_running || start_progress_display
		;;
	*)
		echo "Usage: $0 stop|restore|progress <text>|display|low_mem"
		exit 1
		;;
esac
