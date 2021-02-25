[[  -f ~/.bashrc ]] && . ~/.bashrc


# Remap escape to caps lock and viceversa
# setxkbmap -option caps:swapescape
# Remap caps lock to control and viceversa
#setxkbmap -option ctrl:swapcaps
# xset -b quiets down the bios beep
xset -b

numlockx on
xsetroot -cursor_name left_ptr

ChangeWallpaper

# TFM
#export QT_PLUGIN_PATH="/home/juan/hdd/University/Master/2020-2021/Trabajo fin de master/TFM/src/.venv/lib/python3.9/site-packages/qt5_applications/Qt/plugins/"

export PATH=$PATH:$HOME/.local/bin:$HOME/.emacs.d/bin
export EDITOR=vim
export BROWSER=firefox
export TRUEBROWSER=firefox
export TERMINAL=alacritty
# Themes set with kvanmun manager will actually so something
export QT_STYLE_OVERRIDE=kvantum
# Icons in qt5 applications
export QT_QPA_PLATFORMTHEME="qt5ct"

export PATH="/opt/cuda-10.2/nsight-compute-2019.5.0:$PATH"
export PATH="/opt/cuda-10.2/bin:$PATH"
export CUDA_HOME="/opt/cuda-10.2"
export LD_LIBRARY_PATH="/opt/cuda-10.2/lib64":$LD_LIBRARY_PATH


export MY_RUST_PROJECTS_DIRECTORY="$HOME/hdd/rust"

PANEL_FIFO=/tmp/panel-fifo
PANEL_HEIGHT=24
PANEL_FONT="-*-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
PANEL_WM_NAME=bspwm_panel
export PANEL_FIFO PANEL_HEIGHT PANEL_FONT PANEL_WM_NAME
