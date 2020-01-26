#!/bin/bash

cd $ZYNTHIAN_SW_DIR

#Delete previous build if it exists
if [ -d "kokkinizita" ]; then
	rm -rf kokkinizita
fi

mkdir kokkinizita
cd kokkinizita

#ALSA PCMI library
package_name="zita-alsa-pcmi-0.3.2"
wget https://kokkinizita.linuxaudio.org/linuxaudio/downloads/$package_name.tar.bz2
tar -xf $package_name.tar.bz2
rm -f $package_name.tar.bz2
cd $package_name/source
sed -i 's/SUFFIX/#SUFFIX/g' Makefile
sed -i 's/#SUFFIX)/)/' Makefile
sed -i 's/DESTDIR/NONEDIR/g' Makefile
make -j 4
make install
cd ../..

#CLThreads library
package_name="clthreads-2.4.2"
wget https://kokkinizita.linuxaudio.org/linuxaudio/downloads/$package_name.tar.bz2
tar -xf $package_name.tar.bz2
rm -f $package_name.tar.bz2
cd $package_name/source
sed -i 's/SUFFIX/#SUFFIX/g' Makefile
sed -i 's/#SUFFIX)/)/' Makefile
sed -i 's/DESTDIR/NONEDIR/g' Makefile
make -j 4
make install
cd ../..

#CLXClient library
package_name="clxclient-3.9.2"
wget https://kokkinizita.linuxaudio.org/linuxaudio/downloads/$package_name.tar.bz2
tar -xf $package_name.tar.bz2
rm -f $package_name.tar.bz2
cd $package_name/source
sed -i 's/SUFFIX/#SUFFIX/g' Makefile
sed -i 's/#SUFFIX)/)/' Makefile
sed -i 's/DESTDIR/NONEDIR/g' Makefile
sed -i 's/pkgconf/pkg-config/g' Makefile
sed -i 's/PCONFCFL)/PCONFCFL) -I ./' Makefile
make -j 4
make install
cd ../..

#Aeolus Pipe Organ Emulator
package_name="aeolus-0.9.7"
wget https://kokkinizita.linuxaudio.org/linuxaudio/downloads/$package_name.tar.bz2
tar -xf $package_name.tar.bz2
rm -f $package_name.tar.bz2
cd $package_name/source
sed -i 's/SUFFIX/#SUFFIX/g' Makefile
sed -i 's/#SUFFIX)/)/' Makefile
sed -i 's/DESTDIR/NONEDIR/g' Makefile
sed -i 's/pkgconf/pkg-config/g' Makefile
#Dirty patch to solve "buster bug"
sed -i "s/10000/20000/" tiface.cc
make -j 4
make install
cd ../..
#Create link to binary and global configuration file
ln -s /usr/local/bin/aeolus /usr/bin/aeolus
echo "-u -J -S /usr/share/aeolus/stops" > /etc/aeolus.conf


#Aeolus Stops Configuration
package_name="stops-0.3.0"
wget https://kokkinizita.linuxaudio.org/linuxaudio/downloads/$package_name.tar.bz2
tar -xf $package_name.tar.bz2
rm -f $package_name.tar.bz2
cd $package_name
mkdir "/usr/share/aeolus"
mkdir "/usr/share/aeolus/stops"
cp -rf * "/usr/share/aeolus/stops"
cd ../..

rm -rf "/usr/local/usr"
cd ..
