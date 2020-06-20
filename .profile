[[  -f ~/.bashrc ]] && . ~/.bashrc

# Remap escape to caps lock and viceversa
setxkbmap -option caps:swapescape
# xset -b quiets down the bios beep
xset -b

numlockx on


export PATH=$PATH:$HOME/.local/bin
export EDITOR=vim
export BROWSER=firefox
export TRUEBROWSER=firefox
export TERMINAL=alacritty
# Themes set with kvanmun manager will actually so something
export QT_STYLE_OVERRIDE=kvantum
# Icons in qt5 applications
export QT_QPA_PLATFORMTHEME="qt5ct"



export PATH="$HOME/.cargo/bin:$PATH"
export MY_RUST_PROJECTS_DIRECTORY="$HOME/hdd/rust"
