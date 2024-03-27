#!/usr/bin/env bash

#arguments are (INST_USER,LOG_FILE)
#receiving arguments
#1
INST_USER=$1
#2
LOG_FILE=$2

#do not run this script alone
#run this script by root privilege

#/tmp
#only if the target directory is not on the tmpfs already
if [ "$(mount -v | grep ' /tmp ')" = "" ]; then
  echo "put /tmp on tmpfs?"
  read -p "(y/n)" yn
  if [[ $yn = [yY] ]]; then
    FSTAB="/etc/fstab"
    echo "putting /tmp on tmpfs." | tee $LOG_FILE
    printf "\ntmpfs /tmp tmpfs nodev,nosuid,noatime,rw	0	0\n" >> $FSTAB
  fi
fi

#/home/{usr}/.cache
#only if the target directory is not on the tmpfs already
if [ "$(mount -v | grep ' /home/${INST_USER}/.cache ')" = "" ]; then
  echo "put /home/$INST_USER/.cache on tmpfs?"
  read -p "(y/n)" yn
  if [[ $yn = [yY] ]]; then
    FSTAB="/etc/fstab"
    #user's cache directory
    echo "putting /home/$INST_USER/.cache on tmpfs" | tee $LOG_FILE
    printf "\ntmpfs /home/$INST_USER/.cache tmpfs nodev,nosuid,noatime,rw	0	0\n" >> $FSTAB
  fi
fi


