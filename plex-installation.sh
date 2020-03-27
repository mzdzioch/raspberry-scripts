#!/bin/bash

# Description: Custom script to install and configure Plex in Raspberry Pi.
# Author: Michal Z.
# Date: 2020-03-02
#
# http://raspberrypi.local:32400/web 
#
# How to use:
#   chmod +x plex-installation.sh
#   ./plex-installation.sh
#	
#  ssh file in boot
#  sudo systemctl vnc enable
#
#




# Install Plex

plex_not_installed=$(dpkg -s plex 2>&1 | grep "not installed")
if [ -n "$plex_not_installed" ];then
  echo "Installing Plex"
  sudo apt-get -y update && sudo apt-get upgrade
  sudo apt-get install apt-transport-https -y --force-yes 
  wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key  | sudo apt-key add -
  echo "deb https://dev2day.de/pms/ jessie main" | sudo tee /etc/apt/sources.list.d/pms.list
  sudo apt-get update
  sudo apt-get install -t jessie plexmediaserver -y
fi


# Create an users to access  your shared folders
echo "Change Plex user to media"
sudo nano /etc/default/plexmediaserver
PLEX_MEDIA_SERVER_USER=media

# Add user plex to group media in order to get access to samba share
sudo usermod -G media plex

