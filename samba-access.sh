#!/bin/bash

# Description: Custom script to install and configure Samba in Raspberry Pi.
# Author: Michal Z.
# Date: 2020-03-02
# 
#
# How to use:
#   chmod +x samba-access.sh
#   ./samba-access.sh
#	
#  ssh file in boot
#  sudo systemctl vnc enable



pathLib='/mnt/library'
permissionLib=775

pathSto='/mnt/storage'
permissionSto=775


# Create directory
echo "Create directory"
sudo mkdir /mnt/library
sudo mkdir /mnt/storage


# Install Samba

samba_not_installed=$(dpkg -s samba 2>&1 | grep "not installed")
if [ -n "$samba_not_installed" ];then
  echo "Installing Samba"
  sudo apt-get -y update && sudo apt-get upgrade
  sudo apt-get -y install samba samba-common-bin
fi


# Create an users to access  your shared folders
echo "Create access to shared folders"
sudo addgroup media
sudo useradd -g media media
sudo passwd media
sudo smbpasswd -a media 




# Configure directory that will be accessed with Samba
echo "Configure samba conf file"
echo "
[library]
comment = Library Share
browseable = yes
path = $pathLib
public = no
writable = yes
guest ok = yest
guest only = no
read only = no
create mask = 0$permissionLib
directory mask = 0$permissionLib


[storage]
comment = Storage Share
browseable = yes
path = $pathSto
writeable = yes
public = no
guest ok = yes
guest only = no
read only = no
create mask = 0$permissionSto
directory mask = 0$permissionSto
" | sudo tee -a /etc/samba/smb.conf


# Restart Samba service

sudo /etc/init.d/smbd restart

# Give persmissions to shared directory

sudo chmod -R $permissionLib $pathLib
sudo chmod -R $permissionSto $pathSto

sudo chown -R media:media $pathLib
sudo chown -R media:media $pathSto

# Give permissions to pi user and add permission to the group
sudo usermod -a -G media pi
sudo chmod g+w $pathLib
sudo chmod g+w $pathSto

sudo service smbd restart

# Message to the User
 echo "To access the shared machine from Windows :"
 echo "\\\\$(ifconfig eth0 | sed -n 's/.*dr:\(.*\)\s Bc.*/\1/p')"
