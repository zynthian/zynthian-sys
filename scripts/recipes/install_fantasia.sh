#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ ! -d "fantasia" ]; then
	mkdir fantasia
	cd fantasia
	wget --no-check-certificate http://downloads.sourceforge.net/project/jsampler/Fantasia/Fantasia%200.9/Fantasia-0.9.jar
	# java -jar ./Fantasia-0.9.jar
	cd ..
fi
