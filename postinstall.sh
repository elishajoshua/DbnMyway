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

nala install firmware-linux firmware-linux-free firmware-linux-nonfree firmware-iwlwifi -y

echo "Firmware Install complete"
sleep 10

nala install gnome-core gdm3 gnome-tweaks -y

echo "Gnome Install Complete"
sleep 10

nala install gnupg2 flatpak yad imwheel apt-transport-https curl unzip wget python3 jq pulseaudio pavucontrol neofetch flameshot psmisc pcscd git dirmngr ca-certificates software-properties-common -y

echo "Essential software Install Complete"
sleep 10

nala install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils libguestfs-tools genisoimage virtinst libosinfo-bin virt-manager -y
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu

echo "Virtmgr Install Complete"
sleep 10

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.nextcloud.desktopclient.nextcloud -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.yubico.yubioath -y
flatpak install flathub org.keepassxc.KeePassXC -y

echo "Flatpak Install Complete"
sleep 10

# install vscode
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg >/dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list
nala update
nala install code -y

wget  https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Debian-12-amd64.deb
dpkg -i veracrypt-1.26.7-Debian-12-amd64.deb

latest_angry_ip=$(curl -sL https://api.github.com/repos/angryip/ipscan/releases/latest | jq -r ".assets[].browser_download_url" | grep amd64.deb)
wget $latest_angry_ip
dpkg -i  ${latest_angry_ip##*/} 

#sudo rm -fv /etc/apt/sources.list.d/thorium.list && \
sudo wget --no-hsts -P /etc/apt/sources.list.d/ \
http://dl.thorium.rocks/debian/dists/stable/thorium.list && \
nala update
nala install thorium-browser -y

gdtp=$(curl -sL https://api.github.com/repos/shiftkey/desktop/releases/latest | jq -r ".tag_name")
wget https://github.com/shiftkey/desktop/releases/download/$gdtp/GitHubDesktop-linux-amd64-${gdtp:8:-7}-linux2.deb
dpkg -i  GitHubDesktop-linux-amd64-${gdtp:8:-7}-linux2.deb

apt --fix-borken install

nala autoremove -y

mv /etc/network/interfaces /etc/network/interfaces.old

cp interfaces /etc/network/interfaces

git clone https://github.com/kelebek333/mousewheel.git
cd mousewheel 
chmod +x mousewheel.sh
./mousewheel.sh
cd $builddir

curl -fsSL https://tailscale.com/install.sh | sh

#tailscale up
