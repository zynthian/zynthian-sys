#!/bin/bash

HOST_IP=$(hostname  -I | cut -f1 -d' ')
cd $ZYNTHIAN_SW_DIR/filebrowser
./filebrowser -a $HOST_IP
