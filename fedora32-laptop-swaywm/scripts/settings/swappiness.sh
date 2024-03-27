#!/usr/bin/env bash

#taking arguments
LOG_FILE=$1
CURRENT_SWAPPINESS=$2

#do not run this script alone
#run this script as loot

#make swappiness to 1

SYSCTL_CONF=/etc/sysctl.d/99-sysctl.conf
echo "Current Swappiness is set to $CURRENT_SWAPPINESS"
echo "Do you want to set swappines to 1?"
read -p "(y/n)" yn
if [ $yn = "y" ]; then
  #delete the old swappines setting line if exists  
  sed -i "/.*vm.swappiness.*/d" $SYSCTL_CONF

  #append new swappiness setting
  echo "setting swappiness to 1"
  echo "vm.swappiness=1" >> $SYSCTL_CONF

  echo "vm.swappines changed to 1 (changed $SYSCTL_CONF)" | tee $LOG_FILE
fi



