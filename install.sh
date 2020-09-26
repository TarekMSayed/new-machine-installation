#!/bin/bash
INSTALL_SRC_DIR=$(pwd)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr 0)

echo "$GREEN Installing Basic Packages $RESET"
# TODO enable Canonical Partners repo
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt update
sudo apt upgrade -y
APPS=(
  python3-dev python3-pip virtualenv
  synaptic ubuntu-restricted-extras gufw apt-transport-https
  p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract
  file-roller ssh git curl gnome-tweaks dconf-editor)
$INSTALL_SRC_DIR/aptInstall.sh "${#APPS[@]}" "${APPS[@]}"

# configuration
# TODO force terminal coloring
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
  sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
  APPS+=(qbittorrent)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='MKVtoolnix'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository "deb https://mkvtoolnix.download/ubuntu/ $(lsb_release -sc) main"
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
  sudo add-apt-repository ppa:damien-moore/codeblocks-stable
  APPS+=(codeblocks)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='telegram'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository ppa:atareao/telegram
  APPS+=(telegram)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='VScode'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
  APPS+=(code)
else
  echo "$RED $APP will not installed $RESET"
fi

unset answer
APP='sublime-text-3'
read -p "$YELLOW Do you want to install $APP [y/N]: $RESET" answer
if [[ $answer =~ y|Y|yes ]]; then
  echo "$GREEN Adding $APP $RESET"
  sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  APPS+=(sublime-text)
else
  echo "$RED $APP will not installed $RESET"
fi

echo "$GREEN Installing chosen packages $RESET"
sudo apt update
$INSTALL_SRC_DIR/aptInstall.sh "${#APPS[@]}" "${APPS[@]}"
