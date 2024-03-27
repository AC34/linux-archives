#!/usr/bin/env bash

#taking arguments
LOG_FILE=$1
CURRENT_RATIO=$2

#do not run this script alone
#run this script as root

#make dirty ratio to 10

SYSCTL_CONF=/etc/sysctl.d/99-sysctl.conf
echo "Current vm.dirty_ratio is set to $CURRENT_RATIO"
echo "Do you want to set vm.dirty_ratio to 10?"
read -p "(y/n)" yn
if [ $yn = "y" ]; then
  #delete the old vm.dirty_ratio setting line if exists  
  sed -i "/.*dirty_ratio.*/d" $SYSCTL_CONF

  #append new setting
  echo "setting dirty_rato to 10"
  echo "vm.dirty_ratio=10" >> $SYSCTL_CONF

  echo "vm.dirty_ratio changed to 10 (changed $SYSCTL_CONF)" | tee $LOG_FILE
fi



