cd $ZYNTHIAN_SW_DIR
if [ ! -d "pyliblo" ]; then
	git clone https://github.com/dsacre/pyliblo.git
	cd pyliblo
	python3 ./setup.py build
	python3 ./setup.py install
	cd ..
fi
