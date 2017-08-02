# Update to linuxsampler 2.0

if [ -f "/usr/local/bin/linuxsampler" ]; then
  echo "Already updated to linuxsampler-2.0!"
  exit
fi

# Install some LADSPA plugins for LinuxSampler
apt-get -y install ladspa-sdk wah-plugins tap-plugins vco-plugins swh-plugins ste-plugins rev-plugins omins mcp-plugins invada-studio-plugins-ladspa rubberband-ladspa fil-plugins csladspa cmt caps bs2b-ladspa blop blepvco autotalent ambdec amb-plugins


#Remove LinuxSampler 1 installed from repository
sudo apt remove -y linuxsampler libgig6 liblinuxsampler

# Install LinuxSampler 2.0
source $ZYNTHIAN_SYS_DIR/scripts/recipes/install_linuxsampler.sh
