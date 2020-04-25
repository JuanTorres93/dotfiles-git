#
# ~/.bashrc
#

#Ibus settings if you need them
#type ibus-setup in terminal to change settings and start the daemon
#delete the hashtags of the next lines and restart
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=dbus
#export QT_IM_MODULE=ibus

# If not running interactively, don't do anything
#[[ $- != *i* ]] && return

#export HISTCONTROL=ignoreboth:erasedups

# Make pywal persisten between instances. Import colorscheme from 'wal' asynchronously
(cat ~/.cache/wal/sequences &)

#PS1='[\u@\h \W]\$ '
#Terminal prompt accent
PS1='\[\e[1;35m\][\u@\h \W]\$ \[\e[m\]'

if [ -d "$HOME/.bin" ] ;
	then PATH="$HOME/.bin:$PATH"
fi

#list
alias ls='ls --color=auto'  
alias ll='ls -lh --color=auto'  
alias la='ls -lhA --color=auto'  

alias ..='cd ..'  

alias lns='ln -srfi'  
alias mv='mv -i'  
alias cp='cp -i'  


## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'

#readable output
alias df='df -h'

#get fastest mirrors in your neighborhood 
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

#youtube-dl
alias yta="youtube-dl -ic --extract-audio --audio-format mp3 "
alias yt="youtube-dl -ic "

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

alias listServices='systemctl list-units --type=service'

#Shenanigans
alias StarWars="telnet towel.blinkenlights.nl"
alias tiempo="curl wttr.in"
