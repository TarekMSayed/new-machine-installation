#!/bin/bash
INSTALL_SRC_DIR=$(pwd)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr 0)

echo "$GREEN Installing Basic Packages $RESET"
# enable Canonical Partners repo
sudo sed -i "s~# deb http~deb http~g" /etc/apt/sources.list
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo apt update
sudo apt upgrade -y
APPS=(
  # python
  python3-dev python3-pip virtualenv
  # system utils
  synaptic ubuntu-restricted-extras gufw apt-transport-https htop tmux p7zip-rar p7zip-full 
  unace unrar zip unzip sharutils rar uudeview mpack arj cabextract gedit-plugins
  file-roller ssh git curl vlc terminator gnome-subtitles
  # GUI
  gnome-tweaks dconf-editor)
$INSTALL_SRC_DIR/aptInstall.sh "${#APPS[@]}" "${APPS[@]}"

# configuration
# force terminal coloring
sed -i "s~#force_color_prompt=yes~force_color_prompt=yes~g" ~/.bashrc
source ~/.bashrc
if [[ ! -f ~/.ssh/id_rsa ]]; then
  echo "$GREEN Generate ssh key. $RESET"
  ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
fi

APPS=()

unset answer
APP='qbittorrent'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
  APPS+=(qbittorrent)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='MKVtoolnix'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository -y "deb https://mkvtoolnix.download/ubuntu/ $(lsb_release -sc) main"
  wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | sudo apt-key add -
  APPS+=(mkvtoolnix-gui)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='CodeBlocks'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository -y ppa:damien-moore/codeblocks-stable
  APPS+=(codeblocks)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='telegram'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository -y ppa:atareao/telegram
  APPS+=(telegram)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='simple-screen-recorder'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  APPS+=(simplescreenrecorder)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='VScode'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
#  sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
#  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
  APPS+=(code)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='sublime-text-3'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository -y "deb https://download.sublimetext.com/ apt/stable/"
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  APPS+=(sublime-text)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='docker-ce'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo groupadd docker
  sudo usermod -aG docker ${USER}
  APPS+=(docker-ce)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='virtualbox'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository -y "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  # https://www.techrepublic.com/article/how-to-enable-usb-in-virtualbox/
  sudo groupadd vboxusers
  sudo usermod -aG vboxusers ${USER}
  echo download Extention Back manuall https://www.virtualbox.org/wiki/Downloads
  $INSTALL_SRC_DIR/waitKeyPress.sh
  APPS+=(virtualbox-6.1)
else
  echo "$RED $APP will not installed $RESET"
fi

echo "$GREEN Installing chosen packages $RESET"
sudo apt update
$INSTALL_SRC_DIR/aptInstall.sh "${#APPS[@]}" "${APPS[@]}"
