#!/usr/bin/env bash

#taking arguments
LOG_FILE=$1
CURRENT_D_RATIO=$2

#do not run this script alone
#run this script as loot

#make vm.dirty_background_ratio to 1

SYSCTL_CONF=/etc/sysctl.d/99-sysctl.conf
echo "Current vm.dirty_background_ratio is set to $CURRENT_D_RATIO"
echo "Do you want to set vm.dirty_background_ratio to 3?"
read -p "(y/n)" yn
if [ $yn = "y" ]; then
  #delete the old vm.dirty_background_ratio setting line if exists  
  sed -i "/.*vm.dirty_background_ratio.*/d" $SYSCTL_CONF

  #append new vm.dirty_background_ratio setting
  echo "setting vm.dirty_background_ratio to 3"
  echo "vm.dirty_background_ratio=3" >> $SYSCTL_CONF

  echo "vm.dirty_background_ratio changed to 3 (changed $SYSCTL_CONF)" | tee $LOG_FILE
fi



