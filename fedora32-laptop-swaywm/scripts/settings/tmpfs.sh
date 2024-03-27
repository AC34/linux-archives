#!/usr/bin/env bash

#arguments are (INST_USER,LOG_FILE)
#receiving arguments
#1
INST_USER=$1
#2
LOG_FILE=$2

#do not run this script alone
#run this script by root privilege
echo "tmpfs script user:$INST_USER"

echo "Do you want to put /home/$INST_USER/.cache/* on tmpfs(max 2046M)?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  FSTAB="/etc/fstab"
  #user's cache directory
  echo "putting user's cache directory on tmpfs." | tee $LOG_FILE
  printf "\ntmpfs /home/$INST_USER/.cache tmpfs nodev,nosuid,noatime,size=2046M	0	0\n" >> $FSTAB
fi


