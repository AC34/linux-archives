#!/usr/bin/env bash

#do not run this script alone

#animation control
echo "Do you want to disable GNOME animation?"
read -p "(y/n)" yn
if [ $yn = "y" ]; then
  gsettings set org.gnome.desktop.interface enable-animations false
  echo "GNOME animation disabled" | tee >> $LOG_FILE
fi
echo

#sound event control
echo "Do you want to disable GNOME event-sounds?"
read -p "(y/n)" yn
if [ $yn = "y" ]; then
  gsettings set org.gnome.desktop.sound event-sounds false
  echo "GNOME event-sounds disabled" | tee >> $LOG_FILE
fi
echo

#tracker setting
echo "Do you want to disable Tracker?"
echo "(file indexing,search tools)"
read -p "(y/n)" yn
if [ $yn = "y" ]; then
  systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service
  tracker reset --hard
  echo "Tracker disabled" | tee >> $LOG_FILE
fi
echo



