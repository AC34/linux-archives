#!/usr/bin/env bash

#unisntralls some sway related packages

echo "delete [sway swaybg waybar swaylock mako wofi wdisplays]?"
read -p "(y/n)?" yn
if [[ $yn = [yY] ]]; then
  sudo dnf remove -y sway swaybg waybar swaylock mako wofi wdisplays
fi

echo uninstallation done
