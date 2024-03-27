#!/usr/bin/env bash

#dont run this script alone

#initializing variable
HOST_NAME=$(hostname)

#prompt to change hostname
echo
echo "Your current hostname is [${HOST_NAME}]"
read -p "Do you want to change the hostname? (y/n):" yn
if [ $yn = "n" ]; then
echo
exit
fi


#changing the hostname 
KEEP_ASKING=0
while [ "$KEEP_ASKING" -eq "0" ]
do
  echo
  echo Type in the new hostname:
  read NEW_NAME
  echo "Entered hostname: \"$NEW_NAME\""
  echo
  read -p "Change hostname \"${HOST_NAME}\" to \"${NEW_NAME}\": (y/n)" yn
  if [ $yn = "y" ]; then
    #changing hostname
    sudo hostnamectl set-hostname "${NEW_NAME}"
    #log
    echo "Changed hostname ${HOST_NAME} to ${NEW_NAME}"  | tee $LOG_FILE
    #stop asking
    KEEP_ASKING=1
  else
    read -p "Abort changing name? (y/n)" yn
    if [ $yn = "y" ]; then
      #stop asking
      KEEP_ASKING=1
    fi
  fi  
done
