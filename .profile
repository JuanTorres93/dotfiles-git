[[  -f ~/.bashrc ]] && . ~/.bashrc


# Remap escape to caps lock and viceversa
setxkbmap -option caps:swapescape
# Remap caps lock to control and viceversa
#setxkbmap -option ctrl:swapcaps
# xset -b quiets down the bios beep
xset -b

numlockx on
xsetroot -cursor_name left_ptr

# Launch odoo
cd ~/hdd/Improvement\ engineer/ && docker-compose up -d &
# Return terminal to default path
cd ~

export BOT_ADDRESS='local_ip'

export PATH=$PATH:$HOME/.local/bin:$HOME/.emacs.d/bin
export EDITOR=vim
export BROWSER=firefox
export TRUEBROWSER=firefox
export TERMINAL=alacritty
# Themes set with kvanmun manager will actually so something
export QT_STYLE_OVERRIDE=kvantum
# Icons in qt5 applications
export QT_QPA_PLATFORMTHEME="qt5ct"


PANEL_FIFO=/tmp/panel-fifo
PANEL_HEIGHT=24
PANEL_FONT="-*-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
PANEL_WM_NAME=bspwm_panel
export PANEL_FIFO PANEL_HEIGHT PANEL_FONT PANEL_WM_NAME
