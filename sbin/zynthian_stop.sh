#!/bin/bash

zynthian_pid=$(pgrep -f zynthian_main.py)
if [[ "$zynthian_pid" ]]; then
	if [[ -f "/zynthian/venv/bin/send_osc" ]]; then
		/zynthian/venv/bin/send_osc 1370 /CUIA/EXIT_UI
	else
		send_osc 1370 /CUIA/EXIT_UI
	fi
	while [[ $(pgrep -f zynthian_main.py) == "$zynthian_pid" ]]; do
		sleep 0.1
	done
fi
