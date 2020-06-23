-- IMPORTS

-- Default imports
import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Extra imports
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid



-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2

myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["web","work","job","files","virt","aux","media","term","mail"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#636363"
myFocusedBorderColor = "#789789"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,                 xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm .|. shiftMask,   xK_d     ), spawn "dmenu_run")

    -- launch firefox
    , ((modm .|. controlMask, xK_f     ), spawn "firefox")

    -- launch xkill
    , ((modm,                 xK_Delete), spawn "xkill")

    -- launch thunar
    , ((modm,                 xK_e     ), spawn "thunar")

    -- launch ranger
    , ((modm,                 xK_r     ), spawn "alacritty -e ranger")

    -- launch thunderbird
    , ((modm .|. controlMask, xK_t     ), spawn "thunderbird")
    , ((0, xK_F1                       ), spawn "ChangeWallpaper")

    -- close focused window
    , ((modm ,                xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,                 xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask,   xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,                 xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,                 xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,                 xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,                 xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,                 xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,                 xK_BackSpace), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask,   xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask,   xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,                 xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,                 xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,                 xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              ,   xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              ,   xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ),  spawn "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --expand true --transparent true --alpha 35 --tint 0x0B160B --height 18 &")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_minus     ), io (exitWith ExitSuccess))

    -- Poweroff computer
    , ((modm .|. shiftMask, xK_period     ), spawn "shutdown_confirmation_qtile poweroff")

    -- Reboot computer
    , ((modm .|. shiftMask, xK_comma     ),  spawn "shutdown_confirmation_qtile reboot")

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r     ), spawn "killall xmobar; xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_i, xK_o, xK_p] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

myLayout = 
        mySpacing 5 (avoidStruts(tiled)) |||
        mySpacing 5 (avoidStruts(Grid)) |||
        noBorders Full 
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 0.55

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className  =? "MPlayer"        --> doFloat
    , className  =? "Gimp"           --> doFloat
    , resource   =? "desktop_window" --> doIgnore
    , resource   =? "kdesktop"       --> doIgnore
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Startup hook

myStartupHook = do
       spawnOnce "ChangeWallpaper"
       spawnOnce "picom &"
       spawnOnce "volumeicon &"
       --spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --expand true --transparent true --alpha 35 --tint 0x0B160B --height 18 &"
       spawnOnce "udiskie &"
       --spawnOnce "run nm-applet &"
       spawnOnce "redshift -b 1:0.7 &"
       spawnOnce "parcellite -n &"

------------------------------------------------------------------------

main = do
       xmproc0 <- spawnPipe "xmobar -d -x 0 /home/juan/.config/xmobar/xmobarrc" -- -x 0 means "Launch xmobar in monitor 1"

       xmonad $ docks def 
              {
              manageHook = myManageHook 
                    ,   terminal           = myTerminal
                    ,   focusFollowsMouse  = myFocusFollowsMouse
                    ,   clickJustFocuses   = myClickJustFocuses
                    ,   borderWidth        = myBorderWidth
                    ,   modMask            = myModMask
                    ,   workspaces         = myWorkspaces
                    ,   normalBorderColor  = myNormalBorderColor
                    ,   focusedBorderColor = myFocusedBorderColor
                    ,   keys               = myKeys
                    ,   mouseBindings      = myMouseBindings
                    ,   layoutHook         = myLayout
                    ,   handleEventHook    = myEventHook
                    ,   startupHook        = myStartupHook
              
               -- this adds Xmobar to Xmonad
              , logHook = dynamicLogWithPP xmobarPP 
                 { --ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x  >> hPutStrLn xmproc2 x
                  ppOutput = hPutStrLn xmproc0
                , ppCurrent = xmobarColor "#c3e88d" ""                -- Current workspace in xmobar
                , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                , ppHidden = xmobarColor "#82AAFF" ""                 -- Hidden workspaces in xmobar
                , ppHiddenNoWindows = xmobarColor "#445566" ""        -- Hidden workspaces (no windows)
                , ppTitle = xmobarColor "#d0d0d0" "" . shorten 60     -- Title of active window in xmobar
                , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]

                }
            } 