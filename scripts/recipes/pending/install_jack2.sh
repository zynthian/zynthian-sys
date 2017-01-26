# Jack2
cd $ZYNTHIAN_SW_DIR
sudo apt-get install -y libasound2-dev
git clone https://github.com/jackaudio/jack2.git
cd jack2
./waf configure
./waf build
sudo ./waf install 
./waf clean
cd ..
