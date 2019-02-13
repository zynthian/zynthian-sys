
# 2019-02-12: Delete Autostatic Repository from sources list to avoid apt error messages
if [ -f "/etc/apt/sources.list.d/autostatic-audio-raspbian.list" ]; then
	rm -f "/etc/apt/sources.list.d/autostatic-audio-raspbian.list"
fi

# 2017-11-21 => tornadostreamform, required by zynthian-webconf
res=`pip3 show tornadostreamform`
if [ "$res" == "" ]; then
	pip3 install tornadostreamform
fi

# 2017-11-22 => jack-smf-utils, playback and record MID files
if [ ! -d "$ZYNTHIAN_SW_DIR/jack-smf-utils-1.0" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_jack-smf-utils.sh
fi

# 2017-11-29 => jsonpickle, required by zynthian-webconf
res=`pip3 show jsonpickle`
if [ "$res" == "" ]; then
	pip3 install jsonpickle
fi

# 2018-01-23 => replace jackclient-python by a customized version
if [ ! -d "$ZYNTHIAN_SW_DIR/jackclient-python" ]; then
	yes | pip3 uninstall JACK-Client
	$ZYNTHIAN_RECIPE_DIR/install_jackclient-python.sh
fi

# 2018-03-11 => Install Pianoteq 6.0 Demo
if [ ! -d "$ZYNTHIAN_SW_DIR/pianoteq6" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_pianoteq_demo.sh
	touch $REBOOT_FLAGFILE
fi

# 2018-03-14 => Install Helm Synthesizer & Upgrade System
if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/helm" ]; then
	apt-get -y update
	apt-get -y upgrade
	apt-get -y --no-install-recommends install libxcursor-dev libxinerama-dev libcurl4-openssl-dev mesa-common-dev libgl1-mesa-dev libfreetype6-dev
	$ZYNTHIAN_RECIPE_DIR/install_helm.sh
fi

# 2018-03-14 => Install Infamous Plugins
if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/infamousPlugins" ]; then
	apt-get -y install libzita-resampler-dev
	$ZYNTHIAN_RECIPE_DIR/install_infamous.sh
fi

# 2018-03-14 => Install Invada Plugins
if [ ! -L "$ZYNTHIAN_PLUGINS_DIR/lv2/invada.lv2" ]; then
	apt-get -y --no-install-recommends install invada-studio-plugins-lv2
	ln -s /usr/lib/lv2/invada.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
fi

# 2018-03-14 => Install padthv1
if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/padthv1" ]; then
	apt-get -y update
	apt-get -y --no-install-recommends install qt5-qmake qt5-default
	$ZYNTHIAN_RECIPE_DIR/install_padthv1.sh
fi

# 2018-04-03 => Install QMidiNet
if [ ! -d "$ZYNTHIAN_SW_DIR/qmidinet" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_qmidinet.sh
fi

# 2018-04-08 => Install obxd bank
if [ ! -d "$ZYNTHIAN_SW_DIR/plugins/obxd_bank" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_obxd_bank.sh
fi

# 2018-05-22 => PureData Integration
#if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/presets/puredata" ]; then
res=`pip3 show oyaml`
if [ "$res" == "" ]; then
	apt-get -y update
	apt-get -y upgrade
	apt-get -y install puredata puredata-core puredata-utils python3-yaml
	apt-get -y install pd-lua pd-moonlib pd-pdstring pd-markex pd-iemnet pd-plugin pd-ekext pd-import pd-bassemu pd-readanysf pd-pddp pd-zexy pd-list-abs pd-flite pd-windowing pd-fftease pd-bsaylor pd-osc pd-sigpack pd-hcs pd-pdogg pd-purepd pd-beatpipe pd-freeverb pd-iemlib pd-smlib pd-hid pd-csound pd-aubio pd-earplug pd-wiimote pd-pmpd pd-motex pd-arraysize pd-ggee pd-chaos pd-iemmatrix pd-comport pd-libdir pd-vbap pd-cxc pd-lyonpotpourri pd-iemambi pd-pdp pd-mjlib pd-cyclone pd-jmmmp pd-3dp pd-boids pd-mapping pd-maxlib
	pip3 install oyaml
	systemctl enable a2jmidid
	systemctl start a2jmidid
	touch $REBOOT_FLAGFILE
fi

# 2018-05-29: Install WIFI firmware from non-free repository
res1=`dpkg -s firmware-brcm80211 2>&1 | grep "Status:"`
res2=`dpkg -s firmware-brcm80211 2>&1 | grep "Version:"`
if [ "$res1" != "Status: install ok installed" ] || [ "$res2" == "Version: 1:0.43+rpi6" ]; then
	rpi-update
	cd $ZYNTHIAN_SW_DIR
	wget https://archive.raspberrypi.org/debian/pool/main/f/firmware-nonfree/firmware-brcm80211_20161130-3+rpt3_all.deb
	dpkg -i firmware-brcm80211_20161130-3+rpt3_all.deb
	rm -f firmware-brcm80211_20161130-3+rpt3_all.deb
	touch $REBOOT_FLAGFILE
fi

# 2018-06-07: Update RBPi firmware & Install CRDA for enabling high WIFI channels
if [ ! -f "/sbin/crda" ]; then
	rpi-update
	apt-get -y install crda
	iw reg set ES
	touch $REBOOT_FLAGFILE
fi

# 2018-06-08: Install psutil python library for improving network info features, etc.
res=`pip3 show psutil`
if [ "$res" == "" ]; then
	if [ ! -d "/root/.pip" ]; then
		mkdir /root/.pip
	fi
	echo -e "[GLOBAL]\ntrusted-host = pypi.org files.pythonhosted.org\n" > /root/.pip/pip.conf
	pip3 install psutil
fi

# 2018-08-01: Install aeolus (pipe organ emulator)
res=`dpkg -s aeolus 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	apt-get -y update
	apt-get -y upgrade
	apt-get -y install aeolus mididings
fi

# 2018-08-09: Install mplayer (multimedia player)
res=`dpkg -s mplayer 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	apt-get -y update
	apt-get -y install mplayer
fi

# 2018-09-09: Install extended Jalv from Zynthian Repository
if [ ! -d $ZYNTHIAN_SW_DIR/jalv ]; then
	$ZYNTHIAN_RECIPE_DIR/install_lv2_jalv.sh
fi

# 2018-09-09: Install Ableton-Link support for MOD-HOST
if [ ! -d $ZYNTHIAN_SW_DIR/Hylia ]; then
	$ZYNTHIAN_RECIPE_DIR/install_hylia.sh
	$ZYNTHIAN_RECIPE_DIR/install_pd_extra_abl_link.sh
fi

# 2018-09-12: Install Python3 pexpect library needed for new zyngine_jalv
res=`pip3 show pexpect`
if [ "$res" == "" ]; then
	pip3 install pexpect
	#Update & Rebuild mod-host
	rm -rf $ZYNTHIAN_SW_DIR/mod-host
	$ZYNTHIAN_RECIPE_DIR/install_mod-host.sh
	#Update & Rebuild mod-ttymidi
	rm -rf $ZYNTHIAN_SW_DIR/mod-ttymidi
	$ZYNTHIAN_RECIPE_DIR/install_mod-ttymidi.sh
fi

# 2018-09-21: Install lilv python binding extension
if [ ! -f /usr/lib/python3.4/lilv.py ]; then
	cp $ZYNTHIAN_SW_DIR/lilv/bindings/python/lilv.py /usr/lib/python3.4
fi

# 2018-11-12: Install foo-yc20 LV2-plugin: Combo Organ Emulator
#if [ ! -d "$ZYNTHIAN_SW_DIR/foo-yc20" ]; then
	#$ZYNTHIAN_RECIPE_DIR/install_foo-yc20.sh
#fi

# 2018-11-12: Install Triceratops LV2-plugin: Analogue Synth
if [ ! -d "$ZYNTHIAN_PLUGINS_SRC_DIR/triceratops.lv2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_triceratops.sh
fi

# 2019-02-12: Install Raffo LV2-plugin: MiniMoog Emulator
if [ ! -d "$ZYNTHIAN_PLUGINS_SRC_DIR/moog" ]; then
	apt-get -y update
	apt-get -y install --no-install-recommends libgtkmm-2.4-dev
	$ZYNTHIAN_RECIPE_DIR/install_raffo.sh
fi

# 2019-02-13: Install Kernel 4.18 from HifiBerry
if [ ! -f "/boot/kernel7-hb.img" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_kernel_hb_dacadc.sh
fi

