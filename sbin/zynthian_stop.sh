#!/bin/bash

zynthian_pid=$(pgrep -f zynthian_main.py)
if [[ "$zynthian_pid" ]]; then
	/zynthian/venv/bin/send_osc 1370 /CUIA/EXIT_UI
	while [[ $(pgrep -f zynthian_main.py) == "$zynthian_pid" ]]; do
		sleep 0.1
	done
fi
