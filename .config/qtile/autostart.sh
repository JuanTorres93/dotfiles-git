#!/bin/bash

function run {
	if ! pgrep $1 ;
	then
		$@&
	fi
}

ChangeWallpaper

# Remap escape to caps lock and viceversa
setxkbmap -option caps:swapescape
# xset -b quiets down the bios beep
xset -b

picom --config ~/.config/picom/picom.conf --focus-exclude "x = 0 && y = 0 && override_redirect = true" &
run numlockx on &
run volumeicon &
run udiskie &
#run nm-applet &
redshift -b 1:0.7 &
parcellite -n &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
