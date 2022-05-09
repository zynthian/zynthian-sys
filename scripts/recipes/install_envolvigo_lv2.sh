

# Install an up-to-date rust development environment
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install needed dependencies
apt-get -y install clang liclang-devel

# Install envolvigo LV2 plugin
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/johannes-mueller/envolvigo
cd envolvigo
./install_lv2.sh
mv /root/.lv2/envolvigo.lv2 /usr/local/lib/lv2
cd ..
rm -rf envolvigo
