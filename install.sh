#!/bin/bash
INSTALL_SRC_DIR=$(pwd)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr 0)

echo "$GREEN Installing Basic Packages $RESET"
sudo apt update
sudo apt upgrade -y
sudo apt install -y
APPS=(
	python3-dev python3-pip 
	synaptic ubuntu-restricted-extras gufw 
	p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract
	file-roller ssh git curl gnome-tweaks dconf-editor)
$INSTALL_SRC_DIR/aptInstall.sh "${#APPS[@]}" "${APPS[@]}"

# configuration

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


echo "$GREEN Installing chosen packages Packages $RESET"
$INSTALL_SRC_DIR/aptInstall.sh "${#APPS[@]}" "${APPS[@]}"