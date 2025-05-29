#!/bin/bash

#HOST_IP=$(hostname  -I | cut -f1 -d' ')
HOST_IP="0.0.0.0"
if [ "$HOST_IP" != "" ]; then
	cd $ZYNTHIAN_SW_DIR/filebrowser
	./filebrowser -a $HOST_IP
fi
