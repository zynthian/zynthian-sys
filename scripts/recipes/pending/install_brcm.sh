
mkdir /lib/firmware
mkdir /lib/firmware/brcm
cd /lib/firmware/brcm
wget https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/master/brcm80211/brcm/brcmfmac43430-sdio.bin
wget https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/master/brcm80211/brcm/brcmfmac43430-sdio.txt
modprobe -r brcmfmac
modprobe brcmfmac
