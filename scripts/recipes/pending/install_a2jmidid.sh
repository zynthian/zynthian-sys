# a2jmidid
cd $ZYNTHIAN_SW_DIR
git clone git://repo.or.cz/a2jmidid.git
cd a2jmidid
./waf configure
./waf build
sudo ./waf install 
./waf clean
cd ..
