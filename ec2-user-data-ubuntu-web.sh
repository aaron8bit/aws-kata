#!/bin/bash

# Track timing, progress, and output of user-data script

date > /user-data-output

echo "USER-DATA COMMENT: apt-get update" >> /user-data-output
apt-get update >> /user-data-output 2>&1

#apt-get ugrade -y >> /user-data-output
# This is to make sure the upgrade doesn't die because grub prompts for manual confirmation
echo "USER-DATA COMMENT: apt-get upgrade ..." >> /user-data-output
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

echo "USER-DATA COMMENT: apt-get install apache2" >> /user-data-output
apt-get install -y apache2 >> /user-data-output 2>&1

echo "USER-DATA COMMENT: Creating and configuring web directory" >> /user-data-output
parted /dev/xvdf mklabel gpt >> /user-data-output 2>&1
parted -a opt /dev/xvdf mkpart primary ext4 0% 100% >> /user-data-output 2>&1
mkfs.ext4 /dev/xvdf1 >> /user-data-output 2>&1
echo "/dev/xvdf1   /mnt/www   ext4   defaults   0   0" >> /etc/fstab
mkdir -p /mnt/www >> /user-data-output 2>&1
mount -a >> /user-data-output 2>&1
mkdir -p /mnt/www/html >> /user-data-output 2>&1

echo "Hello AWS World" > /mnt/www/html/index.html

echo "USER-DATA COMMENT: Configuring apache" >> /user-data-output
sed -i 's/Directory\ \/var\/www/Directory\ \/mnt\/www/' /etc/apache2/apache2.conf >> /user-data-output 2>&1
sed -i 's/DocumentRoot\ \/var\/www\/html/DocumentRoot\ \/mnt\/www\/html/' /etc/apache2/sites-enabled/000-default.conf >> /user-data-output 2>&1
update-rc.d apache2 enable >> /user-data-output 2>&1
systemctl start apache2.service >> /user-data-output 2>&1

date >> /user-data-output
echo "USER DATA SCRIPT COMPLETE" >> /user-data-output

echo "REBOOTING" >> /user-data-output
shutdown -r now

