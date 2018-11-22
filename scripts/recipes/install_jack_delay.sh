#!/bin/bash

#Install jack_delay utility
cd $ZYNTHIAN_SW_DIR
wget http://kokkinizita.linuxaudio.org/linuxaudio/downloads/jack_delay-0.4.2.tar.bz2
tar xfvj jack_delay-0.4.2.tar.bz2
cd jack_delay-0.4.2
sed -i -- 's/CXXFLAGS += -march=native/#CXXFLAGS += -march=native/' Makefile
make
make install
make clean
cd ..
rm -f jack_delay-0.4.2.tar.bz2


