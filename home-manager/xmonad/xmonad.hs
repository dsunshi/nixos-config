--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.IO (hClose, hPutStr, hPutStrLn)
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Run (runProcessWithInput, spawnPipe)
import XMonad.Util.NamedScratchpad
import XMonad.Actions.PhysicalScreens

import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))


import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation


import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.WorkspaceHistory

import XMonad.Layout.ShowWName (SWNConfig(..), showWName')

colorScheme = "nord"

colorBack = "#2E3440"
colorFore = "#D8DEE9"

color01 = "#3B4252"
color02 = "#BF616A"
color03 = "#A3BE8C"
color04 = "#EBCB8B"
color05 = "#81A1C1"
color06 = "#B48EAD"
color07 = "#88C0D0"
color08 = "#E5E9F0"
color09 = "#4C566A"
color10 = "#BF616A"
color11 = "#A3BE8C"
color12 = "#EBCB8B"
color13 = "#81A1C1"
color14 = "#B48EAD"
color15 = "#8FBCBB"
color16 = "#ECEFF4"

colorTrayer :: String
colorTrayer = "--tint 0x2E3440"

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
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
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset



-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#4c566a"
myFocusedBorderColor = "#b48ead"

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "dots" spawnNeovide findDots manageDots ]
    where
        spawnNeovide = "neovide --x11-wm-class dots -- -c \"cd ~/ideas/dots/\""
        findDots     = className =? "dots"
        manageDots   = customFloating $ W.RationalRect l t w h
            where
                h = 1/2
                w = 1/2
                t = 1/2
                l = 1/2
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run --font \"iosevka-16\" -l 10 --nb \"#2E3440\" --nf \"#D8DEE9\" --sb \"#B48EAD\" --sf \"#000000\"")

    , ((modm,               xK_d     ), namedScratchpadAction myScratchPads "dots")

    -- switch audio output
    , ((modm,               xK_o     ), spawn "$HOME/.local/bin/dmenu_audio")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_r     ), refresh)

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    , ((modm,               xK_Tab), windows W.focusDown)
    , ((modm,               xK_m  ), windows W.focusMaster)

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

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
        | (key, sc) <- zip [xK_n, xK_e, xK_i] [0..]
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

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
  { swn_font              = "xft:iosevka:bold:size=36"
  , swn_fade              = 1.0
  , swn_bgcolor           = "#1c1f24"
  , swn_color             = "#ffffff"
  }



-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ simplestFloat

myLayout = avoidStruts
    $ windowArrange
    $ T.toggleLayouts floats (tiled ||| Mirror tiled ||| Full ||| floats)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

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
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "dots"           --> doCenterFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ] <+> namedScratchpadManageHook myScratchPads

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
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--


------------------------------------------------------------------------
-- Startup hook

-- Settings for each screen
mode :: String -> String
mode name = " --mode " ++ mode' name

mode' :: String -> String
mode' name
    | name == "eDP-1"     = "1920x1200"
    | name == "DVI-I-2-1" = "1920x1080"
    | name == "DP-1"      = "1920x1080"
    | name == "DP-2"      = "1920x1080"
    | otherwise           = undefined

pos :: String -> String
pos name = " --pos " ++ pos' name

pos' :: String -> String
pos' name
    | name == "eDP-1"     = "0x0"
    | name == "DVI-I-2-1" = "1200x58"
    | name == "DP-1"      = "3120x58"
    | name == "DP-2"      = "3120x58"
    | otherwise           = undefined

rotate :: String -> Int -> String
rotate name count = " --rotate " ++ rotate' name count

rotate' :: String -> Int -> String
rotate' name count
    | name == "eDP-1"     = if count == 1 then "normal" else "left"
    | name == "DVI-I-2-1" = "normal"
    | name == "DP-1"      = "normal"
    | name == "DP-2"      = "normal"
    | otherwise           = undefined

isPrimary :: String -> String
isPrimary name
    | name == "eDP-1"     = ""
    | name == "DVI-I-2-1" = ""
    | name == "DP-1"      = " --primary "
    | name == "DP-2"      = " --primary "
    | otherwise           = undefined

output :: Int -> String -> String
output count name = " --output " ++ name
    ++ isPrimary name
    ++ mode name
    ++ pos name
    ++ rotate name count

-- The number of monitors is the last character of the first line
-- returned by `xrandr --listmonitors`
numMonitors :: String -> Int
numMonitors = digitToInt . last . head . lines

isDisplayPrefix :: Char -> Bool
isDisplayPrefix '+' = True
isDisplayPrefix '*' = True
isDisplayPrefix _   = False

secondWord :: String -> String
secondWord = (!! 1) . words

monitorNames :: String -> [String]
monitorNames = map (dropWhile isDisplayPrefix . secondWord) . tail . lines

xrandr :: String -> String
xrandr stdin
    | count == 2 = xrandr' (names ++ ["DVI-I-2-1"])
    | otherwise  = xrandr' names
    where
        count = numMonitors stdin
        names = monitorNames stdin
        xrandr' names' = "xrandr " ++ unwords (map (output count) names')

digitToInt :: Char -> Int
digitToInt '0' = 0
digitToInt '1' = 1
digitToInt '2' = 2
digitToInt '3' = 3
digitToInt '4' = 4
digitToInt '5' = 5
digitToInt '6' = 6
digitToInt '7' = 7
digitToInt '8' = 8
digitToInt '9' = 9
digitToInt _   = 0

delayedSpawn :: String -> X ()
delayedSpawn c = spawn ("sleep 2 && " ++ c)

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    -- spawn "killall conky"
    result <- runProcessWithInput "xrandr" ["--listmonitors"] []
    spawn $ xrandr result
    spawnOnce "picom"
    -- delayedSpawn "conky -c $HOME/.xmonad/nord.conky"
    delayedSpawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7\" eDP-1"
    delayedSpawn "feh --bg-fill $HOME/.config/wallpapers/totoro-nord.png"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do 
     -- Launching three instances of xmobar on their monitors.
     xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobar.hs"
     xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobar.hs"
     xmproc2 <- spawnPipe "xmobar -x 2 $HOME/.config/xmobar/xmobar.hs"
     xmonad $ docks def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = showWName' myShowWNameTheme myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = dynamicLogWithPP $  filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
        { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
                        >> hPutStrLn xmproc1 x   -- xmobar on monitor 2
                        >> hPutStrLn xmproc2 x   -- xmobar on monitor 3
        , ppCurrent = xmobarColor color06 "" . wrap
                      ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
          -- Visible but not current workspace
        , ppVisible = xmobarColor color06 ""
          -- Hidden workspace
        , ppHidden = xmobarColor color05 "" . wrap
                     ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>"
          -- Hidden workspaces (no windows)
        , ppHiddenNoWindows = xmobarColor color05 ""
          -- Title of active window
        , ppTitle = xmobarColor color16 "" . shorten 60
          -- Separator character
        , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
          -- Urgent workspace
        , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
          -- Adding # of windows on current workspace to the bar
        , ppExtras  = [windowCount]
          -- order of things in xmobar
        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
        },
        startupHook        = myStartupHook
    }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
