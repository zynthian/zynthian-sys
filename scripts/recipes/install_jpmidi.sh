cd $ZYNTHIAN_SW_DIR
if [ ! -d "jpmidi-0.21" ]; then
	wget https://github.com/jerash/jpmidi/archive/v0.21.tar.gz -O jpmidi-0.21.tar.gz
	tar xfvz jpmidi-0.21.tar.gz
	cd jpmidi-0.21/jpmidi
	./configure
	make -j 4
	cp ./src/jpmidi /usr/local/bin
	cd ../..
	rm -f jpmidi-0.21.tar.gz
fi
