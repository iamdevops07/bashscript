#!bin/bash

echo "Enter user name for ftp : - "
read name 

sudo apt-get install vsftpd
echo "step 1 done"

sudo sed -i "/listen=/c\listen=YES" /etc/vsftpd.conf

sudo sed -i "/anonymous_enable=/c\anonymous_enable=YES" /etc/vsftpd.conf

sudo sed -i "/listen_ipv6=/c\listen_ipv6=NO" /etc/vsftpd.conf

sudo sed -i "/#write_enable=/c\write_enable=YES" /etc/vsftpd.conf

sudo sed -i "0,/#chroot_local_user=YES/s//chroot_local_user=YES/" /etc/vsftpd.conf

sudo echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf


echo "vsftpd file editing done"

sudo service vsftpd restart
echo "step 2 done"

sudo service vsftpd status
echo "step 3 done"

sudo adduser $name
echo "step 4 done"

sudo chown root:root /home/$name
echo "step 5 done"

sudo usermod --home /var/www $name
echo "step 6 done"

sudo service vsftpd restart
echo "step 7 done"

# Change write permission

sudo usermod -a -G $name www-data

echo "step 8 done"

sudo setfacl -R -m u:$name:rwx /var/www
echo "step 9 done"


