#     _                     _____                        
#    | |_   _  __ _ _ __   |_   _|__  _ __ _ __ ___  ___ 
# _  | | | | |/ _` | '_ \    | |/ _ \| '__| '__/ _ \/ __|
#| |_| | |_| | (_| | | | |   | | (_) | |  | | |  __/\__ \
# \___/ \__,_|\__,_|_| |_|   |_|\___/|_|  |_|  \___||___/
#                                                        
#					  Qtile Config

import os
import subprocess
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook


from typing import List  # noqa: F401

mod = "mod4"
alt = "mod1"
control = "control"


#================ KEYS ================
keys = [
# Switch between windows in current stack pane
Key([mod], "j", lazy.layout.down()),
Key([mod], "k", lazy.layout.up()),

# Move windows up or down in current stack
Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

# Send window to master
Key([mod], "BackSpace", lazy.layout.swap_main()),

# RESIZE
Key([mod], "i", lazy.layout.grow()),
Key([mod], "m", lazy.layout.shrink()),
Key([mod], "l", lazy.layout.grow_main()),
Key([mod], "h", lazy.layout.shrink_main()),

# Switch window focus to other pane(s) of stack
# SUPER + KEYS
Key([mod], "v", lazy.cmd_swap_main()),
Key([mod], "e", lazy.spawn('thunar')),
Key([mod], "r", lazy.spawn("alacritty -e ranger")),
Key([mod], "Return", lazy.spawn("alacritty")),
Key([mod], "f", lazy.window.toggle_fullscreen()),

# Toggle between different layouts as defined below
Key([mod], "space", lazy.next_layout()),
Key([mod, "shift"], "space", lazy.prev_layout()),
Key([mod], "q", lazy.window.kill()),

Key([mod, "shift"], "r", lazy.restart()),
Key([mod, "shift"], "minus", lazy.shutdown()),
Key([mod, "shift"], "period", lazy.spawn("shutdown_confirmation_qtile poweroff")),
Key([mod, "shift"], "comma", lazy.spawn("shutdown_confirmation_qtile reboot")),

# SPECIALL KEYS
Key([], "F1", lazy.spawn("ChangeWallpaper")),
Key([], "F5", lazy.spawn("zathura /home/juan/Segundo\ cuatrimestre/Sistemas\ de\ energía\ eléctrica/Indice/Indice.pdf")),

# MULTIMEDIA KEYS

# INCREASE/DECREASE BRIGHTNESS
Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),

# INCREASE/DECREASE/MUTE VOLUME
Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),

Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

# SUPER + CONTROL KEYS

Key([mod, control], "a", lazy.spawn("xfce4-appfinder")),
Key([mod, control], "s", lazy.spawn("xfce4-screenshooter -r")),
Key([mod, control], "f", lazy.spawn("firefox")),
Key([mod, control], "l", lazy.spawn("texstudio")),
Key([mod, control], "t", lazy.spawn("thunderbird")),
Key([], "Print", lazy.spawn("ScreenCapture")),

# SUPER + SHIFT KEYS
Key([mod, "shift"], "d", lazy.spawn("dmenu_run -i -fn 'DroidSansMono:italics:pixelsize=17' -sb '#AF1620'")),
]

#================ GROUPS ================

groups = []

groups_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

groups_labels = ["", "", "", "", "", "", "", "", "", ""]	#Margin_y is used to align the group labels, the margin differs...
# https://fontawesome.com/cheatsheet  

groups_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall"]

for i in range(len(groups_names)):
	groups.append(
		Group(
			name=groups_names[i],
			layout=groups_layouts[i].lower(),
			label=groups_labels[i],
			)
		)

for i in groups:
    keys.extend([
        # mod + number of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod + shift + numberª of group = move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),

        Key([mod], "Tab", lazy.screen.next_group()),
        Key([mod, "shift"], "Tab", lazy.screen.prev_group()),
    ])

groups[6]
#================ LAYOUTS ================
colors=[
	"#FF7C00",	#0 - Color of the active border	(windows)
	"#55445E",	#1 - Color of the NON active border (windows)
	"#FF7C00",	#2 - Color of the active group	(bar)
	"#1f232f",	#3 - Color of the bar's background	(bar)
	"#f3f4f5",	#4 - Color of NON empty group	(bar)
	"#a9a9a9",	#5 - Color of empty group	(bar)
	"#1B275C",	#6 - Color 2 of powerline       (bar)
	"#265061",	#7 - Color 1 of powerline	(bar)
	"#B82C32"	#8 - Color of urgent message    (bar)
	]

def init_layout_theme():
	return {"margin":8, 
		"border_width":2, 
		"border_focus": colors[0],
		"border_normal": colors[1]
	}

layout_theme = init_layout_theme()

layouts = [
        layout.MonadTall(**layout_theme, ratio = 0.55, 
                         #new_at_current = True,
                         ),
	layout.RatioTile(**layout_theme),
	layout.MonadWide(**layout_theme),
]


#================ WIDGETS ================
sep_padding = 10
sep_linewidth = 1

widget_defaults = dict(
    font='awesome',
    #font='Droid Sans Mono',
    fontsize=13,
    padding=2,
    background=colors[3]
)
extension_defaults = widget_defaults.copy()


#================ SCREENS ================
screens = [
    Screen(
        top=bar.Bar(
            [
		#widget.Sep(
			#linewidth = 0,
			#padding = 2,
			#foreground = colors[4]
			#),

                widget.GroupBox(
			active = colors[4],
			borderwidth=3,
			center_aligned=True,
			disable_drag = True,
			font="awesome",
			hide_unused = True,
			highlight_method = "line",
			this_current_screen_border = colors[2],
			highlight_color = "#555555",    #Background color when highliht_method = line
			inactive = colors[5],
			rounded = False,
			urgent_border = colors[8],
                        ),

		widget.Sep(
			linewidth = sep_linewidth,
			padding = sep_padding,
			foreground = colors[4]
			),

                widget.WindowName(),

                #widget.TextBox(
                        #"",
                        #fontsize = 40,
                        #padding = -1,
                        #foreground = colors[7],
                        #background = colors[3]),

                #widget.Pacman(
                        #execute = "alacritty -e sudo pacman -Syu && cleanup",
                        #background = colors[7]),

                widget.TextBox(
                        "",
                        fontsize = 40,
                        padding = -1,
                        foreground = colors[6],
                        #background = colors[7]
                        ),

                widget.Clock(
                        format='%d-%m-%Y',
                        background = colors[6]),

                widget.TextBox(
                        "",
                        fontsize = 40,
                        padding = -1,
                        foreground = colors[7],
                        background = colors[6]),

                widget.Clock(format='%H:%M:%S',
                        background = colors[7]),

                #widget.Sep(
			#linewidth = sep_linewidth,
			#padding = sep_padding,
			#foreground = colors[4]
			#),
#
                widget.TextBox(
                        "",
                        fontsize = 40,
                        padding = -1,
                        foreground = colors[6],
                        background = colors[7]),

                widget.Systray(
                        padding = 9,
                        background = colors[6]),

                widget.Sep(
			linewidth = 0,
			padding = 10,
                        background = colors[6],
			foreground = colors[4]
			),

            ],
            24,
            opacity=0.93
        ),
    ),
]


#================ MOUSE ================
# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List

main = None

@hook.subscribe.startup_once
def start_once():
	home = os.path.expanduser('~')
	subprocess.call([home + '/.config/qtile/autostart.sh'])

@hook.subscribe.startup
def start_always():
	subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'xpad'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])

auto_fullscreen = True
focus_on_window_activation = "smart"


wmname = "LG3D"
