#!/bin/bash

res=`/usr/bin/aplay -l | grep "bcm2835 Headphones"`
if [ "$res" != "" ]; then
        echo -n "Headphones"
        exit
fi

res=`/usr/bin/aplay -l | grep "bcm2835 ALSA"`
if [ "$res" != "" ]; then
        echo -n "ALSA"
        exit
fi
