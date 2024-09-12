#!/bin/bash

zynthian_pid=$(pgrep zynthian.sh)
if [[ "$zynthian_pid" ]]; then
	/zynthian/venv/bin/send_osc 1370 /CUIA/EXIT_UI
	while [[ $(pgrep zynthian.sh) == "$zynthian_pid" ]]; do
		sleep 0.1
	done
fi

