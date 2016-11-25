# mod-ui
cd $ZYNTHIAN_SW_DIR
git clone --recursive https://github.com/zynthian/mod-ui.git
cd mod-ui
sudo pip3 install -r requirements.txt
cd utils
make
