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

# Retrieve theming
git clone https://github.com/JuanTorres93/wallpapers

# Remove the .git folder from all downloaded repositoires
rm -rf ./*/.git

# Create Background folder
wallpapersDir="$HOME"/.wallpapers
sudo mkdir "$wallpapersDir"

# Move the wallpapers to the backgrounds folder created above
sudo mv wallpapers/* "$wallpapersDir"
# Remove the wallpapers folder, downloaded from repository
rm -rf wallpapers

# Move lightdm background and profile pic to /usr/share/lightdmPictures
# this is done because I couldn't figure out how to enable lightdm to get
# images from home directory
sudo mv lightdmPictures/ /usr/share/

# Dot files configuration
./SoftLinkFiles

# Vim configuration
./vimSetUp.sh

# Set keyboard layout as Spanish
sudo localectl set-x11-keymap es
# Enable the display manager
sudo systemctl enable lightdm

sudo sed -i s/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/ /etc/systemd/system.conf
sudo systemctl daemon-reload
# Enable clock sync
sudo systemctl enable systemd-timesyncd.service
# Enable cronie for cronetabw
sudo systemctl enable cronie
# Allow microphone to be functional
sudo echo "load-module module-alsa-source device=hw:0,0" >> /etc/pulse/default.pa
pulseaudio -k; pulseaudio -D
