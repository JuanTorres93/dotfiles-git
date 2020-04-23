#!/bin/bash

function run {
	if ! pgrep $1 ;
	then
		$@&
	fi
}

ChangeWallpaper

#xset -b quiets down the bios beep
xset -b
picom --config ~/.config/picom/picom.conf --focus-exclude "x = 0 && y = 0 && override_redirect = true" &
run numlockx on &
run volumeicon &
run udiskie &
#run nm-applet &
redshift &
parcellite -n &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
