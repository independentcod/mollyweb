#!/bin/bash
# How to host a website with SSL 
## Including a template of the Official site of Playboy Model Molly Eskam - https://www.mollyeskam.net
## (Made by me)
# Follow Molly Eskam Here:
## https://www.instagram.com/mollyeskam/
# Her YouTube Channel:
## https://www.youtube.com/user/velvetevening1
## An Apache2 installation on Debian is preferred.
# HOW TO INSTALL (Pretty simple)
## git clone https://github.com/independentcod/mollyweb.git && sh mollyweb/bootstrap.sh
### I made this repository only because of that if I die someday someone can take this website and re-host it.
### Everything I do I do it for Molly Eskam and the community.

echo ***Install required files***;
if [ -f "/usr/bin/yum" ]; then
    sudo yum install epel-release alien mod_ssl httpd php nmap whois -y
fi
if [ -f "/usr/bin/apt" ]; then
   sudo apt update && sudo apt install apache2 php nmap whois -y
fi
echo ***Make Apache directories***;
sudo mkdir /var/www;
sudo mkdir /var/www/html;
sudo mkdir /etc/apache2/logs/;
echo ***Get main website***;
sudo wget -O mollywebsite.tar.gz https://archive.org/download/mollywebsite.tar_update/mollywebsite.tar.gz;
echo ***decompress***;
sudo tar xvf mollywebsite.tar.gz -C /var/www/html/;
echo ***make a temporary directory***;
sudo mkdir /root/mollywebsite;
echo ***change directory***;
cd mollywebsite;
echo ***make directory for the lounge live chat plugin***;
sudo mkdir /etc/thelounge;
echo ***move necesary files from temp thelounge directory to program directory***;
sudo cp -r /var/www/thelounge/* /etc/thelounge/;
if [ -f "/usr/bin/yum" ]; then
    echo ***convert thelounge .deb to .rpm for CentOS***;
    sudo alien -r /var/www/html/thelounge_4.1.0_all.deb
    echo ***install thelounge .rpm***;
    sudo rpm -i /var/www/html/thelounge_4.1.0_all.noarch.rpm
fi
if [ -f "/usr/bin/apt" ]; then
    echo ***install thelounge for Debian***;
    sudo apt install nodejs -y;
    sudo dpkg -i /var/www/html/thelounge_4.1.0_all.deb
    echo ***resolving thelounge dependencies.***;
    sudo apt -f install -y;
fi
echo ***move the config file into the correct OS directory***;
if [ -f "/usr/bin/yum" ]; then
sudo cp -r /var/www/html/httpd.conf /etc/httpd/conf/;
fi
if [ -f "/usr/bin/apt" ]; then
sudo cp -r /var/www/html/apache2.conf /etc/apache2/apache2.conf;
fi
echo ***Give permissions***;
sudo chmod +rwx /etc/thelounge -R;
sudo chmod +rwx /var/www/html -R;
echo ***Activate SSL***;
a2enmod ssl;
cd /etc/apache2;
echo ***Get some config files needed***;
wget -O sites-enabled/000-default.conf https://archive.org/download/mollywebsite.tar/000-default.conf;
wget -O conf-enabled/other-vhosts-access-log.conf https://archive.org/download/mollywebsite.tar/other-vhosts-access-log.conf;
echo ***start thelounge***;
sudo thelounge start&
echo ***Make certificates directories***;
sudo mkdir /etc/letsencrypt/
sudo mkdir /etc/letsencrypt/live;
sudo mkdir /etc/letsencrypt/live/www.mollyeskam.net;
echo ***Get the certificates***;
sudo wget -O /root/mollywebsite/cert.zip https://archive.org/download/mollywebsite.tar/cert.zip;
echo ***Decompress certs***;
cd /etc/letsencrypt/live/www.mollyeskam.net;
sudo unzip /root/mollywebsite/cert.zip;
echo ***Start Apache Web Server***;
if [ -f "/usr/bin/apt" ]; then
sudo service apache2 start;
fi
if [ -f "/usr/bin/yum" ]; then
sudo service httpd start
fi
cd ~;
echo "Setup complete, Apache2 is running on port ::80 ::443";
