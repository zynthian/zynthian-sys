cd $ZYNTHIAN_SW_DIR
if [ ! -d "alsaseq-0.4.1" ]; then
	wget http://pp.com.mx/python/alsaseq/alsaseq-0.4.1.tar.gz
	tar xfvz alsaseq-0.4.1.tar.gz
	cd alsaseq-0.4.1
	python3 setup.py install
	cd ..
	rm -f alsaseq-0.4.1.tar.gz
fi
