#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Install nala
apt install nala -y

# Unistall system libreoffice (Don't worry, we will reinstall it later)
nala purge libreoffice*
nala autoclean
nala autoremove

# Installing additional repositories
add-apt-repository ppa:gerardpuig/ppa
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

# Update to fetch new repositories
nala update -y

# Installing Essentials 
nala install  unzip wget install apt-transport-https curl build-essential  tilix  ubuntu-restricted-extras ttf-mscorefonts-installer guvcview snapd synapse -y

# Installing Other less important Programs
nala install neofetch bashtop htop papirus-icon-theme fonts-noto-color-emoji discord gimp mricron gnome-tweaks git software-properties-common ubuntu-cleaner -y

# Installing my work stuff
nala install mricron git-lfs

# Installing some flatpaks
flatpak update
flatpak install com.synology.SynologyDrive io.github.mimbrero.WhatsAppDesktop 

# Installing some snaps I need for convenience (Yes, snaps.... but in my experience these work better as snaps than flatpaks)
snap install code mailspring notion-snap-reborn zotero-snap libreoffice

# Switching to zsh
nala install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/.themes
mkdir -p /home/$username/.icons
mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Pictures/backgrounds
cp -R dotconfig/* /home/$username/.config/
cp bg.jpg /home/$username/Pictures/backgrounds/
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir 
nala install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*


# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors



# Beautiful bash
git clone https://github.com/ChrisTitusTech/mybash
cd mybash
bash setup.sh
cd $builddir

# Use nala
bash scripts/usenala
