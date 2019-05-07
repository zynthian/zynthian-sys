# Jack2
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/jackaudio/jack2.git
cd jack2
git checkout 1.9.12
./waf configure
./waf build
./waf install 
./waf clean
cd ..
