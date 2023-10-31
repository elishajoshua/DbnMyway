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

nala install gnupg2 flatpak yad imwheel apt-transport-https curl unzip wget pulseaudio pavucontrol neofetch flameshot psmisc papirus-icon-theme fonts-noto-color-emoji -y
nald install pcscd git dirmngr ca-certificates software-properties-common ark kwrite kcalc okular python3 -y

nala update

apt remove konqueror -y

#apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils libguestfs-tools genisoimage virtinst libosinfo-bin virt-manager
#sudo adduser $USER libvirt
#sudo adduser $USER libvirt-qemu

curl -fsSL https://tailscale.com/install.sh | sh


# Install brave-browser
wget https://dl.thorium.rocks/debian/dists/stable/thorium.list
sudo mv thorium.list /etc/apt/sources.list.d/
sudo apt update
sudo apt install thorium-browser -y

# install vscode
#nala install dirmngr ca-certificates software-properties-common apt-transport-https curl -y
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg >/dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list
nala update
sudo apt install code



flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.nextcloud.desktopclient.nextcloud -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.yubico.yubioath -y
flatpak install flathub org.gabmus.whatip -y
flatpak install flathub com.github.Murmele.Gittyup -y
flatpak install flathub com.github.Murmele.Gittyup -y

wget  https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Debian-12-amd64.deb
dpkg -i veracrypt-1.26.7-Debian-12-amd64.deb

nala update 
nala upgrade -y


git clone https://github.com/kelebek333/mousewheel.git
cd mousewheel 
chmod +x mousewheel.sh
./mousewheel.sh
cd $builddir


tailscale up
