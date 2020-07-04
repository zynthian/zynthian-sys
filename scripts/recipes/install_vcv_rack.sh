#!/bin/bash
# Install xpra
apt-get -y install xpra
systemctl disable xpra

# Install xrdp
apt-get install xrdp

# Install VCV Rack
cd $ZYNTHIAN_SW_DIR

wget https://github.com/hexdump0815/vcvrack-dockerbuild-v1/releases/download/v1.1.6_3/vcvrack.raspbian-v1.tar.gz

rm -rf vcvrack.raspbian-v1
tar xf vcvrack.raspbian-v1.tar.gz
rm vcvrack.raspbian-v1.tar.gz

cd vcvrack.raspbian-v1

# Configure VCV Rack
echo '{
  "token": "",
  "windowSize": [
    1024.0,
    768.0
  ],
  "windowPos": [
    0.0,
    0.0
  ],
  "zoom": 0.0,
  "invertZoom": false,
  "cableOpacity": 0.5,
  "cableTension": 0.5,
  "allowCursorLock": false,
  "realTime": false,
  "sampleRate": 32000.0,
  "threadCount": 2,
  "paramTooltip": false,
  "cpuMeter": false,
  "lockModules": false,
  "frameRateLimit": 5.0,
  "frameRateSync": false,
  "autosavePeriod": 60.0,
  "patchPath": "",
  "cableColors": [
    "#c9b70e",
    "#0c8e15",
    "#c91847",
    "#0986ad"
  ]
}' > settings.json

echo '#!/bin/bash
# Rack (and therefore Xpra) needs to be run in Racks binary location
cd $ZYNTHIAN_SW_DIR/vcvrack.raspbian-v1
xpra start-desktop :100 --start-child="$ZYNTHIAN_SW_DIR/vcvrack.raspbian-v1/Rack -d" --exit-with-children --xvfb="Xorg :10 vt7 -auth .Xauthority -config xrdp/xorg.conf -noreset -nolisten tcp" --start-via-proxy=no --systemd-run=no --file-transfer=no --printing=no --resize-display=no --mdns=no --pulseaudio=no --dbus-proxy=no --dbus-control=no --webcam=no --notifications=no
' > start-vcv-rack.sh
chmod +x start-vcv-rack.sh

echo '#!/bin/bash
xpra stop :100
' > stop-vcv-rack.sh
chmod +x stop-vcv-rack.sh

mkdir -p $ZYNTHIAN_MY_DATA_DIR/presets/vcvrack
cp autosave.vcv $ZYNTHIAN_MY_DATA_DIR/presets/vcvrack/default.vcv