#!/usr/bin/env bash

#------PREPARATION---------------------
#initial message
echo starting fedora desktop setup
echo
echo The Author of this script is not responsible for any changes this script makes to your OS and your data.
echo You need to be completely sure and be responsible of what you do with this script.

#prompt to continue
read -p "continue? (y/n): " yn
if [ $yn = "n" ]; then
  echo bye
  exit
fi
echo

#abort if user is root
if [ `whoami` = "root" ]; then
 echo "You are logged in as root."
 echo "Run this script by a user."
 echo "aborting"
 exit
else
  echo "you are logged in as \"$(whoami)\""	
  echo "continuing"
  echo
fi

#initializing variables
LOG_FILE="fedora_setup_log.txt"
INST_USER=$(whoami)
FEDORA_VERSION=$(rpm -E %fedora)
CURRENT_SWAPPINESS=0
CURRENT_DIRTY_RATIO=0
CURRENT_DIRTY_BACKGROUND_RATIO=0
FUSION_FREE=0
FUSION_NON_FREE=0
CHROME=0

#abort if not fedora 32
if [ $FEDORA_VERSION != "32" ]; then
  echo "whoops, your machine isn't fedora 32"
  echo "This script is only for fedora 32"
  echo "abort"
  exit
  echo
fi

#------OS SETTINGS---------------------

#changing host name
bash ./scripts/settings/change_hostname.sh $LOG_FILE

#gnome ui related settings
bash ./scripts/settings/gnome_desktop.sh $LOG_FILE

#enable rpm fusion free
echo "Do you want to enable rpm fusion free?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  FUSION_FREE=1
  sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm
fi
echo

#enable rpm fusion non-free
echo "Do you want to enable rpm fusion non-free?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  FUSION_NON_FREE=1
   sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm
fi
echo

#enable google chrome
echo "Do you want to enable goolge-chrome repository?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  CHROME=1
  sudo dnf config-manager --set-enabled google-chrome
fi

#swappines to 1(need root)
CURRENT_SWAPPINESS=$(cat /proc/sys/vm/swappiness)
if [ CURRENT_SWAPPINESS != "1" ]; then 
  echo "loading swappines setting script(need root)"
  sudo bash ./scripts/settings/swappiness.sh $LOG_FILE $CURRENT_SWAPPINESS
fi
echo

#dirty_ratio to 10(need root)
CURRENT_DIRTY_RATIO=$(cat /proc/sys/vm/dirty_ratio)
if [ CURRENT_DIRTY_RATIO != "10" ]; then 
  sudo bash ./scripts/settings/dirty_ratio.sh $LOG_FILE $CURRENT_DIRTY_RATIO
  echo
fi

#dirty_background_ratio to 3(need root)
CURRENT_DIRTY_BACKGROUND_RATIO=$(cat /proc/sys/vm/dirty_background_ratio)
if [ CURRENT_DIRTY_RATIO != "3" ]; then 
  sudo bash ./scripts/settings/dirty_background_ratio.sh $LOG_FILE $CURRENT_DIRTY_BACKGROUND_RATIO
  echo
fi

#tmpfs setting(need root)
if ! grep -q "tmpfs /home/$(whoami)/.cache.*" "/etc/fstab"; then
  #user's .cache directory is already on tmpfs
  sudo bash ./scripts/settings/tmpfs.sh $INST_USER $LOG_FILE
  echo
fi

#natural scrolling of touchpad
LIBINPUT_CONF="/usr/share/X11/xorg.conf.d/20-natural-scrolling.conf"
if [ -e /usr/bin/libinput ]; then
  if [ ! -e $LIBINPUT_CONF ]; then
    echo "Set natural scrolling for touchpad(not mouse)?"
    echo "(natural scrolling=two finger scroll down motion and screen follows)"
    echo "(unnatural scrolling=two finger scroll down motion and screen goes up(scroll bar goes down))"
    echo "(updates $LIBINPUT_CONF)"
    read -p "(y/n)" yn
    if [[ $yn = [yY] ]]; then
      sudo bash ./scripts/settings/natural_scrolling.sh $LOG_FILE $LIBINPUT_CONF
    fi
  fi
fi
echo

#------SOFTWARE INSTALLATION--------------

PACKAGES=""
#vim
VIM_CHOICES="vim-enhanced vim-X11 neovim cancel"
PS3="Choose your vim or choose cancel(number):"
select SELECTED_VIM in $VIM_CHOICES
do
  if [ $SELECTED_VIM = "cancel" ]; then
    break
  else
    PACKAGES="$PACKAGES $SELECTED_VIM"
    echo "You have chosen $SELECTED_VIM"
    break
  fi
done
echo

#common desktop packages
echo "Do you want to install [htop git clamtk pulseaudio-qpaeq ufw ntfs-3g bash-completion fwupd udiskie]?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  PACKAGES="$PACKAGES htop git clamtk pulseaudio-qpaeq ufw ntfs-3g bash-completion fwupd udiskie" 
  echo
fi

#pythons
echo "Do you want to install [python3 python3-pip]?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  PACKAGES="$PACKAGES python3 python3-pip"  
fi
echo

#extra packaages
echo "Do you want to isntall [kitty]?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  PACKAGES="$PACKAGES kitty"  
fi
echo

#powerlines
echo "Do you want to isntall [powerline powerline-fonts]?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  PACKAGES="$PACKAGES powerline powerline-fonts"  
fi
echo

#sway related packages
echo "Do you want to install [sway swaybg waybar swaylock pavucontrol mako wofi ranger wdisplays NetworkManager-tui]?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  PACKAGES="$PACKAGES sway swaybg waybar swaylock pavucontrol mako wofi ranger wdisplays NetworkManager-tui" 
fi
echo

#drawings retouching images
echo "Do you want to install [inkscape]?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  PACKAGES="$PACKAGES inkscape" 
fi
echo
echo "Do you want to install [krita]?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  PACKAGES="$PACKAGES krita" 
fi
echo
echo "Do you want to install [gimp]?"
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  PACKAGES="$PACKAGES gimp" 
fi
echo

#FUSION FREE
#vlc cmus
#only if FUSION_FREE is installed
if [ $FUSION_FREE = "1" ]; then
  echo "Do you want to install [vlc cmus]?"
  read -p "(y/n)" yn
  if [[ $yn = [yY] ]]; then
    PACKAGES="$PACKAGES vlc cmus"
  fi
fi

#google chrome
if [ $CHROME = "1" ]; then
  echo "Do you want to install [google-chrome-stable]?"
  read -p "(y/n)" yn
  if [[ $yn = [yY] ]]; then
    PACKAGES="$PACKAGES google-chrome-stable"
  fi
fi

echo
echo "Installing the folling:$PACKAGES"
echo This may take a while
sudo dnf install -y $PACKAGES
echo Instalation done.
echo

#------OS SETTINGS after installation---------------------

#ufw
#only if ufw is in the selected list
if [[ "$PACKAGES" == *"ufw"* ]]; then
  echo "Set ufw as [deny incoming] and [allow outgoing]?"
  read -p "(y/n)" yn
    if [[ $yn = [yY] ]]; then
	sudo ufw enable
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	sudo ufw reload
    fi
fi

echo All the tasks are done.
echo Reboot required.
echo Reboot now?
read -p "(y/n)" yn
if [[ $yn = [yY] ]]; then
  sudo reboot
else
  echo bye
fi
