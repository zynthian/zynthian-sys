#!/bin/bash

# Alsa Mixer Settings
if [ "$SOUNDCARD_NAME" == "Z2 ADAC" ] || [ "$SOUNDCARD_NAME" == "ZynADAC" ] || [ "$SOUNDCARD_NAME" == "HifiBerry DAC+ ADC PRO" ]; then
	echo "Configuring Alsa Mixer for $SOUNDCARD_NAME..."
	amixer -c sndrpihifiberry sset 'Auto Mute' mute
	amixer -c sndrpihifiberry sset 'Auto Mute Mono' mute

elif [ "$SOUNDCARD_NAME" == "AudioInjector" ]; then
	echo "Configuring Alsa Mixer for $SOUNDCARD_NAME..."
	amixer -c audioinjectorpi sset 'Output Mixer HiFi' unmute
	amixer -c audioinjectorpi cset numid=10,iface=MIXER,name='Line Capture Switch' 1

elif [ "$SOUNDCARD_NAME" == "AudioInjector Ultra" ]; then
	echo "Configuring Alsa Mixer for $SOUNDCARD_NAME..."
	amixer -c audioinjectorul cset name='DAC Switch' 0
	amixer -c audioinjectorul cset name='DAC Volume' 240
	amixer -c audioinjectorul cset name='DAC INV Switch' 0
	amixer -c audioinjectorul cset name='DAC Soft Ramp Switch' 0
	amixer -c audioinjectorul cset name='DAC Zero Cross Switch' 0
	amixer -c audioinjectorul cset name='De-emp 44.1kHz Switch' 0
	amixer -c audioinjectorul cset name='E to F Buffer Disable Switch' 0
	amixer -c audioinjectorul cset name='DAC Switch' 1
fi
