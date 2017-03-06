#!/bin/bash

cd /tmp

yum -y install gcc glibc glibc-common gd gd-devel httpd make autoconf automake libgd openssl openssl-devel libssl-dev libssl libgd-dev libc6-dev >> /root/nagios-install.log

groupadd -g 9000 nagios && echo "create nagios group OK !" >> /root/nagios-install.log
groupadd -g 9001 nagcmd && echo "create nagcmd group OK !" >> /root/nagios-install.log
useradd -u 9000 -g nagios -G nagcmd -d /home/nagios -c "Nagios Admin" nagios && echo "create nagios user OK !" >> /root/nagios-install.log

usermod -G nagcmd apache

mkdir /usr/local/nagios
chown -R nagios:nagios /usr/local/nagios

#https://www.nagios.org/downloads/nagios-core/thanks/
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-3.5.1.tar.gz
#https://www.nagios.org/downloads/nagios-plugins/
wget https://nagios-plugins.org/download/nagios-plugins-2.1.4.tar.gz

cp nagios-3.5.1.tar.gz /usr/local/src
cp nagios-plugins-2.1.4.tar.gz /usr/local/src

cd  /usr/local/src
tar xzvf nagios-3.5.1.tar.gz
cd nagios-3.5.1
./configure --prefix=/usr/local/nagios --with-nagios-user=nagios --with-nagios-group=nagios --with-command-group=nagcmd --enable-embedded-perl --with-perlcache
make all
make install
make install-init
make install-commandmode
make install-webconf
make install-config

cd /usr/local/src/
tar zxvf nagios-plugins-2.1.4.tar.gz 
cd nagios-plugins-2.1.4
./configure --prefix=/usr/local/nagios --with-nagios-user=nagios --with-nagios-group=nagios --with-perl-modules
make && make install
