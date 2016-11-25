# LV2, lilv and Python bindings
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/drobilla/lv2.git
cd lv2
./waf configure
./waf build
sudo ./waf install
./waf clean
cd ..
git clone --recursive http://git.drobilla.net/serd.git/
cd serd
./waf configure
./waf build
sudo ./waf install
./waf clean
cd ..
git clone --recursive http://git.drobilla.net/sord.git/
cd sord
./waf configure
./waf build
sudo ./waf install
./waf clean
cd ..
git clone http://git.drobilla.net/sratom.git sratom
cd sratom
./waf configure
./waf build
sudo ./waf install
./waf clean
cd ..
git clone --recursive http://git.drobilla.net/lilv.git lilv
cd lilv
#./waf configure --bindings --python=/usr/bin/python2
#./waf build
#sudo ./waf install
#./waf clean
./waf configure --bindings --python=/usr/bin/python3
./waf build
sudo ./waf install
./waf clean
cd ..
git clone https://github.com/brunogola/lilv_python_examples
cd lilv_python_examples
2to3 -w *.py
export PYTHONPATH="/usr/local/lib/python3/dist-packages"
python3 lv2ls.py
