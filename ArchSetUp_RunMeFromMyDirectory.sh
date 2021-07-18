#!/bin/bash
# Check processor vendor and install xf86 accordingly (probably useless)
probe_cpu=$(cat /proc/cpuinfo | grep vendor | uniq)

if [[  "$probe_cpu" == *"Intel"*  ]]; then
	sudo pacman -S xf86-video-intel
else
	sudo pacman -S xf86-video-amdgpu
fi

# Dot files configuration
./SoftLinkFiles

# More packages
./Install_from_arch_based_distro

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
