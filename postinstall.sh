#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

nala install kde-plasma-desktop plasma-nm -y

nala install gnupg2 flatpak yad imwheel apt-transport-https curl unzip wget pulseaudio pavucontrol neofetch flameshot psmisc papirus-icon-theme fonts-noto-color-emoji dirmngr ca-certificates software-properties-common -y 

nala update

#apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils libguestfs-tools genisoimage virtinst libosinfo-bin virt-manager
#sudo adduser $USER libvirt
#sudo adduser $USER libvirt-qemu

curl -fsSL https://tailscale.com/install.sh | sh


# Install brave-browser
#nala install apt-transport-https curl -y
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
nala update
nala install brave-browser -y

# install vscode
#nala install dirmngr ca-certificates software-properties-common apt-transport-https curl -y
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg >/dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list
nala update
sudo apt install code


latest_AppImgLuchr=$(curl -sL https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".assets[].browser_download_url" | grep bionic_amd64.deb)
wget $latest_AppImgLuchr
AppImgLuchr=$(printf $latest_AppImgLuchr | cut -d '/' -f9)
dpkg -i  $AppImgLuchr
rm $AppImgLuchr

latest_nextcloud=$(curl -sL https://api.github.com/repos/nextcloud-releases/desktop/releases/latest | jq -r ".assets[].browser_download_url" | grep x86_64.AppImage)
wget $latest_nextcloud
nextcloud=$(printf $latest_nextcloud | cut -d '/' -f9)
chmod +x $nextcloud


latest_github_dsktp=$(curl -sL https://api.github.com/repos/shiftkey/desktop/releases/latest | jq -r ".assets[].browser_download_url"  | grep '\<x86_64.*linux1.AppImage\>' )
wget $latest_github_dsktp
github_dsktp=$(printf $latest_github_dsktp | cut -d '/' -f9)
chmod +x $github_dsktp

latest_picocrypt=$(curl -sL https://api.github.com/repos/HACKERALERT/Picocrypt/releases/latest | jq -r ".assets[].browser_download_url"  | grep Picocrypt.AppImage )
wget $latest_picocrypt
picocrypt=$(printf $latest_picocrypt | cut -d '/' -f9)
chmod +x $picocrypt
./ $picocrypt


flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


git clone https://github.com/kelebek333/mousewheel.git
cd mousewheel 
chmod +x mousewheel.sh
./mousewheel.sh
cd $builddir


tailscale up