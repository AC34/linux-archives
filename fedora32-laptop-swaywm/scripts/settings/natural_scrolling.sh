#!/usr/bin/env bash


#do not run this script alone
#need root privilege

LOG_FILE=$1
CONF=$2

SETTING="\n
Section \"InputClass\"\n
\tIdentifier \"libinput touchpad catchall\"\n
\tDriver \"libinput\"\n
\tMatchIsTouchpad \"on\"\n
\tOption \"NaturalScrolling\" \"true\"\n
EndSection\n
"

#creating the file
touch $CONF
#writing to file
echo -e $SETTING > $CONF

echo "touchpad naturall-scrolling enabled" | tee $LOG_FILE
