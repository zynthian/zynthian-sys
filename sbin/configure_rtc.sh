

# Configuring RV3028 RTC
#echo "dtoverlay=i2c-rtc,rv3028" >> /boot/config.txt

#systemctl disable fake-hwclock
#apt-get -y remove fake-hwclock
#update-rc.d -f fake-hwclock remove

# Setting Up RV308
setup_rv3028.sh

# Adjusting TZ
timedatectl
timedatectl list-timezones
timedatectl set-timezone Europe/Madrid
