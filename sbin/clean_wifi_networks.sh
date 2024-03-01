#!/bin/bash

echo "Deleting WIFI connections..."
nmcli --terse con show | while read row; do
	name=$(echo "$row" | cut -d : -f 1)
	type=$(echo "$row" | cut -d : -f 3)
	if [ "$type" == "802-11-wireless" ]; then
		echo " Deleting $name ..."
		nmcli con del "$name"
	fi
done
