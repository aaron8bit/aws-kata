#!/bin/bash

date > /user-data-output

echo "USER-DATA COMMAND: apt-get update" >> /user-data-output
apt-get update >> /user-data-output 2>&1

#apt-get ugrade -y >> /user-data-output
# This is to make sure the upgrade doesn't die because grub prompts for manual confirmation
echo "USER-DATA COMMAND: apt-get upgrade ..." >> /user-data-output
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

echo "USER-DATA COMMAND: apt-get install apache2" >> /user-data-output
apt-get install -y apache2 >> /user-data-output 2>&1

echo "USER-DATA COMMAND: echo command for index.html" >> /user-data-output
echo "Hello AWS World" > /var/www/html/index.html

echo "USER-DATA COMMAND: update-rc.d apache2 enable" >> /user-data-output
update-rc.d apache2 enable >> /user-data-output 2>&1

echo "USER-DATA COMMAND: systemctl start apache2.service" >> /user-data-output
systemctl start apache2.service >> /user-data-output 2>&1

date >> /user-data-output
echo "USER DATA SCRIPT COMPLETE" >> /user-data-output 2>&1

echo "REBOOTING" >> /user-data-output
shutdown -r now

