#!/bin/bash
# Update the system in order to get pacman functional
sudo pacman -Syu
# Install needed packages
sudo pacman -S --needed tar gzip unzip unrar xarchiver git base-devel networkmanager network-manager-applet alsa-firmware pulseaudio pasystray pavucontrol xorg ttf-font-awesome alsa-utils ranger papirus-icon-theme parcellite
sudo pacman -S --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xterm firefox geany dmenu lxappearance xwallpaper thunar thunar-archive-plugin picom qtile ttf-droid numlockx feh polkit-gnome cronie gvim
sudo pacman -S --needed xfce4-appfinder volumeicon gvfs thunar-volman noto-fonts udisks2 udiskie alsa-utils alacritty xfce4-notifyd kvantum-qt5 qt5ct capitaine-cursors youtube-dl redshift arc-solid-gtk-theme kvantum-theme-arc arc-icon-theme

# Check processor vendor and install xf86 accordingly (probably useless)
probe_cpu=$(cat /proc/cpuinfo | grep vendor | uniq)

if [[  "$probe_cpu" == *"Intel"*  ]]; then
	sudo pacman -S xf86-video-intel
else
	sudo pacman -S xf86-video-amdgpu
fi

# Retrieve needed configurations and theming
git clone https://github.com/JuanTorres93/wallpapers
git clone https://github.com/JuanTorres93/Dotfiles
git clone https://github.com/JuanTorres93/Scripts

# Make the executables, executables
chmod +x ./Dotfiles/.config/*.sh
chmod +x ./Dotfiles/.config/*/*.sh
chmod +x ./Dotfiles/.config/*/*/*.sh

# Remove the .git folder from all repositoires
# This repository
rm -rf ./.git
# Downloaded repositories
rm -rf ./*/.git

# Create Background folder
sudo mkdir /usr/share/backgrounds

# Move the wallpapers to the backgrounds folder created above
sudo mv wallpapers/* /usr/share/backgrounds
# Remove the wallpapers folder, downloaded from repository
rm -rf wallpapers

# Move lightdm background and profile pic to /usr/share/lightdmPictures
# this is done because I couldn't figure out how to enable lightdm to get
# images from home directory

sudo mv lightdmPictures/ /usr/share/

# Dot files configuration
cd Dotfiles
# Move everything except this very folder and its parent to home directory
mv .[!.]* ~/
cd ..
# Scripts configuration
cd Scripts
rm README.*
# Make them executable
chmod +x ./*
mkdir -p ~/.local/bin/
# Move the scripts to the .local/bin folder (must be added to PATH enviromental variable)
mv ./* ~/.local/bin/
# Go one directory above from root repository directory...
cd ..
cd ..
# ... And delete it
rm -rf arch-set-up
#vim configuration
mkdir ~/.vim/bundle
cd ~/.vim/bundle
# These are managed from pathogen
git clone https://github.com/vim-airline/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes
git clone https://github.com/danilo-augusto/vim-afterglow
git clone https://github.com/xuhdev/vim-latex-live-preview

# Set keyboard layout as Spanish
sudo localectl set-x11-keymap es
# Enable the display manager
sudo systemctl enable lightdm

sudo vim -c %s/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s /etc/systemd/system.conf
sudo systemctl daemon-reload
# Enable clock sync
sudo systemctl enable systemd-timesyncd.service
# Enable cronie for cronetabw
sudo systemctl enable cronie
# Allow microphone to be functional
sudo echo "load-module module-alsa-source device=hw:0,0" >> /etc/pulse/default.pa
pulseaudio -k; pulseaudio -D
