#!/bin/bash
HAT_PRODUCT_FILE="/proc/device-tree/hat/product"
HAT_PRODUCT_MATCH="EPDF"

if [ -f $HAT_PRODUCT_FILE ]; then
	HAT_PRODUCT_STR=$(tr -d '\0' <$HAT_PRODUCT_FILE)
	if [ $HAT_PRODUCT_STR == $HAT_PRODUCT_MATCH ]; then
		exit 0
	else
		#Not a matching hat
		exit -2
	fi
fi
#No hat present
exit -1

