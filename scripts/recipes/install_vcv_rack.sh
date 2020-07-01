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