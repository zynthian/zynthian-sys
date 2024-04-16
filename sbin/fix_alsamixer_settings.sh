#!/bin/bash

# Fix ALSA Mixer controllers envar
echo -e "export SOUNDCARD_MIXER=\"$SOUNDCARD_MIXER\"" > /tmp/update_envars.sh
update_size1=$(stat -c%s "/tmp/update_envars.sh")
sed -i -e "s/ADC Left,/ADC_0,/g" /tmp/update_envars.sh
sed -i -e "s/ADC Right,/ADC_1,/g" /tmp/update_envars.sh
sed -i -e "s/Digital Left/Digital_0/g" /tmp/update_envars.sh
sed -i -e "s/Digital Right/Digital_1/g" /tmp/update_envars.sh
sed -i -e "s/Digital_Left/Digital_0/g" /tmp/update_envars.sh
sed -i -e "s/Digital_Right/Digital_1/g" /tmp/update_envars.sh
update_size2=$(stat -c%s "/tmp/update_envars.sh")
if [ "$update_size1" != "$update_size2" ]; then
	echo "Fixing Alsa Mixer Controllers ..."
	update_envars.py /tmp/update_envars.sh no_update_sys
else
	rm -f /tmp/update_envars.sh
fi

# Alsa Mixer Settings
if [ "$SOUNDCARD_NAME" == "Z2 V5" ] || [ "$SOUNDCARD_NAME" == "Z2 ADAC" ] || [ "$SOUNDCARD_NAME" == "ZynADAC" ] || [ "$SOUNDCARD_NAME" == "HifiBerry DAC+ ADC PRO" ]; then
	if [ ! -f "/etc/asound.sndrpihifiberry.state" ]; then
		echo "Configuring Alsa Mixer for $SOUNDCARD_NAME..."
		amixer -c sndrpihifiberry sset 'Auto Mute' mute
		amixer -c sndrpihifiberry sset 'Auto Mute Mono' mute
		amixer -c sndrpihifiberry sset 'Deemphasis' off
		amixer -c sndrpihifiberry sset 'ADC Left Input' 'VINL2[SE] + VINL1[SE]'
		amixer -c sndrpihifiberry sset 'ADC Right Input' 'VINR2[SE] + VINR1[SE]'
		#amixer -c sndrpihifiberry sset 'ADC Left Input' '{VIN1P, VIN1M}[DIFF]}'
		#amixer -c sndrpihifiberry sset 'ADC Right Input' '{VIN2P, VIN2M}[DIFF]}'
		alsactl --file /etc/asound.sndrpihifiberry.state store sndrpihifiberry
		alsactl store
	else
		echo "Alsa Mixer already configured for $SOUNDCARD_NAME..."
	fi

elif [ "$SOUNDCARD_NAME" == "AudioInjector" ]; then
	if [ ! -f "/etc/asound.audioinjectorpi.state" ]; then
		echo "Configuring Alsa Mixer for $SOUNDCARD_NAME..."
		amixer -c audioinjectorpi sset 'Output Mixer HiFi' unmute
		amixer -c audioinjectorpi cset numid=10,iface=MIXER,name='Line Capture Switch' 1
		alsactl --file /etc/asound.audioinjectorpi.state store audioinjectorpi
		alsactl store
	else
		echo "Alsa Mixer already configured for $SOUNDCARD_NAME..."
	fi

elif [ "$SOUNDCARD_NAME" == "AudioInjector Ultra" ]; then
	if [ ! -f "/etc/asound.audioinjectorul.state" ]; then
		echo "Configuring Alsa Mixer for $SOUNDCARD_NAME..."
		amixer -c audioinjectorul cset name='DAC Switch' 0
		amixer -c audioinjectorul cset name='DAC Volume' 240
		amixer -c audioinjectorul cset name='DAC INV Switch' 0
		amixer -c audioinjectorul cset name='DAC Soft Ramp Switch' 0
		amixer -c audioinjectorul cset name='DAC Zero Cross Switch' 0
		amixer -c audioinjectorul cset name='De-emp 44.1kHz Switch' 0
		amixer -c audioinjectorul cset name='E to F Buffer Disable Switch' 0
		amixer -c audioinjectorul cset name='DAC Switch' 1
		alsactl --file /etc/asound.audioinjectorul.state store audioinjectorul
		alsactl store
	else
		echo "Alsa Mixer already configured for $SOUNDCARD_NAME..."
	fi

fi
