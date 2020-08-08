#!/bin/bash

res=`/usr/bin/aplay -l | grep "bcm2835 Headphones"`
if [ "$res" != "" ]; then
        echo "Headphones"
        exit
fi

res=`/usr/bin/aplay -l | grep "bcm2835 Headphones"`
if [ "$res" != "" ]; then
        echo "ALSA"
        exit
fi
