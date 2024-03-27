#!/usr/bin/env bash

#https://AC34/.deb10setup.git

echo "Starting debian i3 polybar japanese installation."

#confirm changes
echo 
echo This script makes various and some significant changes to your OS and your data.
echo The Author of this script is totally not responsible/reliable/accountable for any harm this script does to your OS and your data.
echo You need to be completely sure and totally be responsible of what you are doing with this script.
echo Press \"y\" to proceed. Press 
echo Press \"n\" to abort.
read -n1 -p "press y or n" yn
if [[ $yn = [yY] ]]; then
  echo "y pressed. proceeding"
else
  echo "n pressed. proceeding"
	echo "aborting"
	echo "bye"
	exit
fi

#global variables
USER=""
DISTRO=""
#this nedds tobe modified

#check weather logged in as root
#abort if user isn't root
if [ `whoami` = "root" ]; then
 echo "logged in as root. continuing"
else
		echo
		echo "user needs to be logged in as root. you are \"$(whoami)\" now."	
	echo "login as root by \"su\" and try again."
	echo "You might need to do [sudo su] right after installation"
	exit
fi

#select user for installation
echo
title="User Selection"
prompt="Select user for this isntallation:"
PS3=$prompt
candidates=`ls /home`
select INST_USER in $candidates
do
 if [ "$INST_USER" = "" ]; then
		 echo "invalid selection. choose again."
 else
   echo "selected $INST_USER "
	 break
 fi
done

#initializing log file
echo "installtion started:$(date)"
if [[ "$(uname -a)" == *"Debian"* ]]; then
		DISTRO=Debian
else
		DISTRO="not supported"
fi

#abort on unsupported os
if [ "$DISTRO" = "not supported" ];then
		echo "distro not supported"
		echo "aborting."
		exit
else
		echo "Distro found as ${DISTRO}. continuing."
fi

#move to user's directory
cd /home/$INST_USER/

#sources.list backports,contrib,non-free registeration
echo
echo "updating sources.list"
printf "deb http://deb.debian.org/debian/ buster main contrib non-free
deb-src http://deb.debian.org/debian/ buster main contrib non-free

deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free

# buster-updates, previously known as 'volatile'
deb http://deb.debian.org/debian/ buster-updates main contrib non-free
deb-src http://deb.debian.org/debian/ buster-updates main contrib non-free

deb http://deb.debian.org/debian/ buster-backports main contrib non-free

" >> /etc/apt/sources.list

#update before installatiion
apt -y update
apt -y upgrade
apt -y autoclean

#install apps

apt install -y i3 xorg xinit lightdm dbus-x11
apt -y autoremove

echo "removing vim-tiny. vim-gtk will be installed instead."
echo "in order to be able to use clipboard, installing vim-gtk instead of vim-tiny" 
apt -y remove vim-tiny
apt -y autoremove

apt install -y i3 ntfs-3g polybar sudo rofi compton compton-conf udiskie wget rxvt-unicode-256-color
apt -y autoremove

apt install -y htop ufw pulseaudio network-manager nm-tray 
apt -y autoremove

apt install -y bash-completion nitrogen bc
apt -y autoremove

apt install -y psmisc libxrandr2 arandr ranger 
apt -y autoremove

apt -y install python3 python3-pip
apt -y autoremove

apt -y install chkrootkit

echo "python3 is installed. if python2 is installed before, command python might refer to python2. In order to call python3 by "python", make alias in your .bashrc or .bash_aliases."

apt -y install cmus git powerline fonts-powerline
apt -y autoremove

apt -y install -t buster-backports firefox-esr
apt -y autoremove

apt -y install -t buster-backports chromium

apt -y install -t buster-backports neovim

apt -y install -t buster-backports vlc pulseaudio-equalizer

apt -y autoremove

apt -y update
apt -y upgrade
apt -y autoclean

#register user as sudoer
echo "registering $INST_USER as sudoer"
USERMOD=$(whereis usermod | cut -d" " -f2 )
$USERMOD -aG sudo $INST_USER

#docker installation
#assuming there are no old packages
echo
echo "docker installation"
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable contrib non-free"
#apt needs to be updated here
apt update
#install
sudo apt-get -y install docker docker-ce docker-ce-cli containerd.io
#add user to the docker group
$USERMOD -aG docker $INST_USER

#japanese locale setting
echo
echo "Locale Setting"
echo "Current Locale is:$LANG" 
echo "If you want to change locale setting, press y"
echo "press n to avoid making changes."
read -n1 -p "press y or n" yn
if [[ $yn = [yY] ]]; then
  dpkg-reconfigure locales
  echo "locale changed to $LANG" 
	echo "changes you made take effect after reboot."
fi

#japanese input setting
echo "Japanese input Seting"
echo "Install and Enable Japanese Input(ibus-mozc)?"
echo "press y to make changes"
echo "press n to avoid making changes."
read -n1 -p "press y or n:" yn
if [[ $yn = [yY] ]]; then
  echo "Enabling Japanese Input"
  apt install -y ibus-mozc 
  echo "instaled ibus-mozc" 
fi

#keyboard setting
echo "Keyboard Setting"
echo "Configure Keyboard Setting?"
echo "press y to make changes"
echo "press n to avoid making changes."
read -n1 -p "press y or n:" yn
if [[ $yn = [yY] ]]; then
  dpkg-reconfigure keyboard-configuration
	setupcon
fi

#natural scroll setting
NATURAL_SCROLL_CONF=/usr/share/X11/xorg.conf.d/20-natural-scrolling.conf
if [ ! -f $NATURAL_SCROLL_CONF ]; then
  NATURAL_SCROLL_SETTING="\n
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
  echo -e $NATURAL_SCROLL_SETTING > $NATURAL_SCROLL_CONF
fi

#dirty_ratio to 10
CURRENT_DIRTY_RATIO=$(cat /proc/sys/vm/dirty_ratio)
if [ CURRENT_DIRTY_RATIO != "10" ]; then
  SYSCTL_CONF=/etc/sysctl.d/99-sysctl.conf
  #delete the old vm.dirty_ratio setting line if exists
  sed -i "/.*dirty_ratio.*/d" $SYSCTL_CONF
  #append new setting
  echo "setting dirty_rato to 10"
  echo "vm.dirty_ratio=10" >> $SYSCTL_CONF
  echo "vm.dirty_ratio changed to 10 (changed $SYSCTL_CONF)"
fi


#seting dirty_background_ratio to 1
CURRENT_DIRTY_BACKGROUND_RATIO=$(cat /proc/sys/vm/dirty_background_ratio)
if [ $CURRENT_DIRTY_BACKGROUND_RATIO != "3" ]; then
  SYSCTL_CONF=/etc/sysctl.d/99-sysctl.conf
  echo "Current vm.dirty_background_ratio is set to $CURRENT_DIRTY_BACKGROUND_RATIO"
  echo "Do you want to set vm.dirty_background_ratio to 3?"
  read -p "(y/n)" yn
  if [ $yn = "y" ]; then
    #delete the old vm.dirty_background_ratio setting line if exists
    sed -i "/.*vm.dirty_background_ratio.*/d" $SYSCTL_CONF
  
    #append new vm.dirty_background_ratio setting
    echo "setting vm.dirty_background_ratio to 3"
    echo "vm.dirty_background_ratio=3" >> $SYSCTL_CONF
  
    echo "vm.dirty_background_ratio changed to 3 (changed $SYSCTL_CONF)"
  fi
fi


#make swappiness to 1
SYSCTL_CONF=/etc/sysctl.conf
echo
echo "Swappiness setting"
if ! grep -q "vm.swappiness=.*" "/etc/sysctl.conf"; then
	CURRENT_SWAPPINESS=$(cat $SYSCTL_CONF | grep "vm.swappiness" | sed --quiet "s/vm.swappiness.*=//g")
  echo "Current Swappiness is $CURRENT_SWAPPINESS"
  echo "Do you want to set swappines to 1?"
  echo "press y to make changes"
  echo "press n to avoid making changes."
  read -n1 -p "press y or n:" yn
  if [[ $yn = [yY] ]]; then
  #delete the old swappines setting lineif exists  
  sed -i "/.*vm.swappiness.*/d" $SYSCTL_CONF
  #append new swappiness setting
	echo "setting swappiness to 1"
  printf "\nvm.swappiness=1\n" >> $SYSCTL_CONF
  fi
else
  echo "swappiness is already set to 1. making no changes."
fi

#tmpfs
echo
echo "Tmpfs setting"
echo "Do auto tmpfs setting?"
echo "press y to make changes"
echo "press n to avoid making changes."
read -n1 -p "press y or n:"
if [[ $yn = [yY] ]]; then
  FSTAB="/etc/fstab"
  echo #for the sake of giving a  new line
	#user's cache directory
	if ! grep -q "tmpfs /home/$INST_USER/.cache.*" "/etc/fstab"; then
    echo "putting user's cache directory on tmpfs."
    printf "\ntmpfs /home/$INST_USER/.cache tmpfs nodev,nosuid,noatime,size=2046M	0	0\n" >> $FSTAB
  else
    echo "user's cache folder is already on tmpfs. making no change."
  fi
  #tmp on tmpfs
	if ! grep -q "tmpfs /tmp.*" "/etc/fstab"; then
    echo "putting /tmp on tmpfs."
    printf "tmpfs /tmp tmpfs nodev,nosuid,noatime,size=1024M	0	0\n" >> $FSTAB
  else
    echo "/tmp is already on tmpfs. making no change."
  fi
fi


#lightdm gtk
echo
echo "lightdm gtk greeter setting"
LIGHTDM_CONF=/usr/share/lightdm/lightdm.conf.d/01_debian.conf
if ! [ -f $LIGHTDM_CONF ]; then
		echo "conf did not exist=$LIGHTDM_CONF"
		echo "creating new one."
    touch $LIGHTDM_CONF
fi
#[Seat:*] setting
#list users by setting false to greeter-hide-users
if grep -Eixq ".*hide-users.*=.*true.*" $LIGHTDM_CONF; then
	LCONF=$(cat $LIGHTDM_CONF | sed -r "s/.*hide-users.*=.*true/hide-users=false/g")
	echo "$LIGHTDM_CONF modified, now showing users at login."
	printf "$LCONF" > $LIGHTDM_CONF
else
  if grep -Eixq ".*greeter-hide-users.*=.*false.*" $LIGHTDM_CONF; then
		echo "greeter-hide-users is already false."
  else
#no preset user property set.
#writing brand new setting
     printf "[Seat:*]\ngreeter-session=lightdm-greeter\ngreeter-hide-users=false\nsession-wrapper=/etc/X11/Xsession\n" > $LIGHTDM_CONF
  fi
fi

#[SeatDefaults] setting of lightdm
#set seat defaults
if ! grep -Eixq ".*default-user.*=.*" $LIGHTDM_CONF; then
  echo "printing new seat deafults"
  printf "\n\n[SeatDefaults]\ndefault-user=${inst_user}" >> $LIGHTDM_CONF
fi

#ufw
if [ $(command -v ufw) != "" ]; then
  ufw enable
  ufw default deny incoming
  ufw default allow outgoing
  ufw reload
fi

#clamav settings
echo ""
echo "ClamAv settings"
apt install -y clamav clamtk 
echo "ClamAv and ClamTk is installed. to use ClamAv, use GUI frontend Clamtk."

echo every process is done. you need to reboot


