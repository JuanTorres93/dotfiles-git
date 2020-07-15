#     _                     _____
#    | |_   _  __ _ _ __   |_   _|__  _ __ _ __ ___  ___
# _  | | | | |/ _` | '_ \    | |/ _ \| '__| '__/ _ \/ __|
#| |_| | |_| | (_| | | | |   | | (_) | |  | | |  __/\__ \
# \___/ \__,_|\__,_|_| |_|   |_|\___/|_|  |_|  \___||___/
#
#						~/.bashrc


# Make pywal persistent between instances. Import colorscheme from 'wal' asynchronously
#(cat ~/.cache/wal/sequences &)

#Terminal prompt accent
PS1='\[\e[1;35m\][\u@\h \W]\$ \[\e[m\]'

if [ -d "$HOME/.bin" ] ;
	then PATH="$HOME/.bin:$PATH"
fi

# Activate vi mode
set -o vi

# ----- ALIASES -----
# changing programs
alias ls='exa --color=auto'  
alias ll='exa -l --color=auto'  
alias la='exa -la --color=auto'  

# adding flags
#alias ls='ls --color=auto'  
#alias ll='ls -lh --color=auto'  
#alias la='ls -lhA --color=auto'  

alias diff='diff --color=auto'  
alias ..='cd ..'  
alias lns='ln -srfi'  
alias mv='mv -i'  
alias cp='cp -i'  

alias grep='grep --color=auto'
alias df='df -h'

alias yta="youtube-dl -ic --extract-audio --audio-format mp3 "
alias yt="youtube-dl -ic "

alias subdl="subdl --existing=overwrite "
alias subdl-name="subdl --existing=overwrite --force-filename "

# Useful aliases
alias cdr="cd $MY_RUST_PROJECTS_DIRECTORY"

alias gs="git status "
alias ga="git add "
alias gr="git remove "
alias gc="git commit -m  "
alias gpom="git push origin master "

#get fastest mirrors in your neighborhood 
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"


#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

alias listServices='systemctl list-units --type=service'

#Shenanigans
alias StarWars="telnet towel.blinkenlights.nl"
alias tiempo="curl wttr.in"
alias listfonts="fc-list"
