#!/bin/bash

export ZYNTHIAN_CONFIG_DIR="/home/txino/Zynthian/config"
source $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh

apt -y install asoundlib-dev libboost-python-dev libboost-thread-dev liblo librubberband-dev
apt -y python3-evdev 
apt -y install rubberband-cli a2jmidid

$ZYNTHIAN_RECIPE_DIR/install_lv2-lilv.sh
$ZYNTHIAN_RECIPE_DIR/install_lv2-jalv.sh
$ZYNTHIAN_RECIPE_DIR/install_libsndfile.sh

cd "$ZYNTHIAN_DIR"
python3 -m venv venv --system-site-packages
source "$ZYNTHIAN_DIR/venv/bin/activate"

pip3 install --upgrade pip

# zynthian-ui
pip3 install JACK-Client alsa-midi oyaml adafruit-circuitpython-neopixel-spi Levenshtein \
ffmpeg-python pyrubberband mididings sox meson ninja abletonparsing hwmon vcgencmd \

# zynthian-webconf
pip3 install tornado tornadostreamform websocket-client tornado_xstatic terminado xstatic XStatic_term.js

$ZYNTHIAN_RECIPE_DIR/install_tkinterweb.sh

# -------------------------
# To run zynthian-ui ...
# -------------------------

# Prepare environment
export ZYNTHIAN_CONFIG_DIR="/home/txino/Zynthian/config"
#export PATH=$PATH:$ZYNTHIAN_SYS_DIR/sbin
source "$ZYNTHIAN_DIR/venv/bin/activate"

# Stop pipewire (if it's running)
systemctl --user stop pulseaudio.socket && systemctl --user stop pulseaudio.service
systemctl --user stop pipewire.socket && systemctl --user stop pipewire.service
systemctl --user stop pipewire-pulse.socket && systemctl --user stop pipewire-pulse.service

# Start jack in a separated terminal
jackd $JACKD_OPTIONS &
a2jmidid &

# Run zynthian-ui
cd $ZYNTHIAN_UI_DIR
source $ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh
export PYTHONFAULTHANDLER=1
export ZYNTHIAN_LOG_LEVEL=10
export ZYNTHIAN_UI_POWER_SAVE_MINUTES="0"
# Normal
./zynthian.sh
# Debug mode
export ZYNTHIAN_LOG_LEVEL=10
export ZYNTHIAN_DEBUG_THREAD=1
./zynthian_main.py



