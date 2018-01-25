# jack-smf-utils => jack MID-file playback & recording
cd $ZYNTHIAN_SW_DIR
wget --no-check-certificate https://downloads.sourceforge.net/project/jack-smf-utils/jack-smf-utils/1.0/jack-smf-utils-1.0.tar.gz
tar xfvz jack-smf-utils-1.0.tar.gz
rm -f jack-smf-utils-1.0.tar.gz
cd jack-smf-utils-1.0
./configure
make -j 4
make install
make clean
cd ..
