import Data.List
import Data.Map qualified as M
import GHC.IO.Handle
import Prompt.Eval
import System.Exit
import Text.Printf
import XMonad
import XMonad.Actions.WorkspaceNames
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Gaps
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Spacing
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch (fuzzyMatch)
import XMonad.StackSet qualified as W
import XMonad.Util.Cursor
import XMonad.Util.Run

myTerminal = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = map show [1 .. 9]

-- Border colors for unfocused and focused windows, respectively.
-- Colors taken from "regular" kanagawa
myNormalBorderColor = "#1F1F28"

myFocusedBorderColor = "#B9B4D0"

myFont = "xft:ioseveka:size=14:hinting=0:antialias=1"

myBgColor = "black"

myDefaultColor = "green"

myXPConfig :: XPConfig
myXPConfig =
  def
    { font = myFont,
      bgColor = myBgColor,
      fgColor = myDefaultColor,
      bgHLight = myBgColor,
      fgHLight = myFocusedBorderColor,
      borderColor = myNormalBorderColor,
      promptBorderWidth = 1,
      height = 32,
      position = Top,
      historySize = 100000,
      historyFilter = deleteConsecutive,
      searchPredicate = fuzzyMatch
      --    , autoComplete        = Nothing
    }

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
-- TODO: Ezconfig
-- https://hackage.haskell.org/package/xmonad-contrib-0.18.1/docs/XMonad-Util-EZConfig.html
-- https://www.youtube.com/watch?v=gPQ9mn9Nkpc @ 27:32
-- https://github.com/vonabarak/xmonad-config/blob/master/src/Keys.hs
myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
      -- launch dmenu
      ((modm, xK_p), spawn "rofi -show drun"),
      -- launch Haskell prompt
      ((modm .|. shiftMask, xK_p), evalPrompt myXPConfig),
      -- close focused window
      ((modm .|. shiftMask, xK_c), kill),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),
      -- Move focus to the next window
      ((modm, xK_Tab), windows W.focusDown),
      -- Move focus to the next window
      ((modm, xK_j), windows W.focusDown),
      -- Move focus to the previous window
      ((modm, xK_k), windows W.focusUp),
      -- Move focus to the master window
      ((modm, xK_m), windows W.focusMaster),
      -- Swap the focused window and the master window
      ((modm, xK_Return), windows W.swapMaster),
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      -- Swap the focused window with the previous window
      ((modm .|. shiftMask, xK_k), windows W.swapUp),
      -- Shrink the master area
      ((modm, xK_h), sendMessage Shrink),
      -- Expand the master area
      ((modm, xK_l), sendMessage Expand),
      -- Push window back into tiling
      ((modm, xK_t), withFocused $ windows . W.sink),
      -- Increment the number of windows in the master area
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))),
      -- Toggle the status bar gap
      -- Use this binding with avoidStruts from Hooks.ManageDocks.
      -- See also the statusBar function from Hooks.DynamicLog.
      --
      -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
      ((modm, xK_z), spawn "setxkbmap -layout us -variant colemak_dh_ortho"),
      ((modm .|. shiftMask, xK_z), spawn "setxkbmap -layout us"),
      -- Quit xmonad
      ((modm .|. shiftMask, xK_q), spawn "rofi -show power-menu -modi power-menu:rofi-power-menu"),
      -- ((modm .|. shiftMask, xK_q), io exitSuccess),
      -- Restart xmonad
      ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart"),
      -- Run xmessage with a summary of the default keybindings (useful for beginners)
      ((modm .|. shiftMask, xK_slash), spawn ("echo \"" ++ help ++ "\" | xmessage -file -")),
      -- volume
      ((0, xK_F2), spawn "pamixer -d 5"),
      ((0, xK_F3), spawn "pamixer -i 5"),
      -- screen brightness
      ((0, xK_F7), spawn "brightnessctl set 5%- -d intel_backlight"),
      ((0, xK_F8), spawn "brightnessctl set 5%+ -d intel_backlight")
    ]
      ++
      --
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      --
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      ++
      --
      -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
      --
      [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w
            >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w ->
          focus w
            >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
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
myLayout =
  let gapSize = 7
   in gaps [(D, 40)] $
        spacingRaw True (Border gapSize gapSize gapSize gapSize) True (Border gapSize gapSize gapSize gapSize) True $
          tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

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
myManageHook =
  composeAll
    [ className =? "MPlayer" --> doFloat,
      className =? "Gimp" --> doFloat,
      -- className =? "dwarfort" --> doFloat,
      -- className =? "Dwarf_Fortress" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
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
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook :: X ()
-- myLogHook = return ()

myTitlePP :: String -> String
myTitlePP t = if isFirefox t then justFirefox else t
  where
    isFirefox = isInfixOf justFirefox
    justFirefox = "Mozilla Firefox"

-- myXmobarPP :: ScreenId -> PP
-- myXmobarPP s  = filterOutWsPP [scratchpadWorkspaceTag] . marshallPP s $ def
--   { ppSep = ""
--   , ppWsSep = ""
--   , ppCurrent = xmobarColor cyan "" . clickable wsIconFull
--   , ppVisible = xmobarColor grey4 "" . clickable wsIconFull
--   , ppVisibleNoWindows = Just (xmobarColor grey4 "" . clickable wsIconFull)
--   , ppHidden = xmobarColor grey2 "" . clickable wsIconHidden
--   , ppHiddenNoWindows = xmobarColor grey2 "" . clickable wsIconEmpty
--   , ppUrgent = xmobarColor orange "" . clickable wsIconFull
--   , ppOrder = \(ws : _ : _ : extras) -> ws : extras
--   , ppExtras  = [ wrapL (actionPrefix ++ "n" ++ actionButton ++ "1>") actionSuffix
--                 $ wrapL (actionPrefix ++ "q" ++ actionButton ++ "2>") actionSuffix
--                 $ wrapL (actionPrefix ++ "Left" ++ actionButton ++ "4>") actionSuffix
--                 $ wrapL (actionPrefix ++ "Right" ++ actionButton ++ "5>") actionSuffix
--                 $ wrapL "    " "    " $ layoutColorIsActive s (logLayoutOnScreen s)
--                 , wrapL (actionPrefix ++ "q" ++ actionButton ++ "2>") actionSuffix
--                 $  titleColorIsActive s (shortenL 81 $ logTitleOnScreen s)
--                 ]
--   }
--   where
--     wsIconFull   = "  <fn=2>\xf111</fn>   "
--     wsIconHidden = "  <fn=2>\xf111</fn>   "
--     wsIconEmpty  = "  <fn=2>\xf10c</fn>   "
--     titleColorIsActive n l = do
--       c <- withWindowSet $ return . W.screen . W.current
--       if n == c then xmobarColorL cyan "" l else xmobarColorL grey3 "" l
--     layoutColorIsActive n l = do
--       c <- withWindowSet $ return . W.screen . W.current
--       if n == c then wrapL "<icon=/home/amnesia/.config/xmonad/xmobar/icons/" "_selected.xpm/>" l else wrapL "<icon=/home/amnesia/.config/xmonad/xmobar/icons/" ".xpm/>" l

-- https://hackage.haskell.org/package/xmonad-contrib-0.18.1/docs/XMonad-Hooks-DynamicLog.html#v:dynamicLogWithPP
xmobarHook :: [Handle] -> X ()
xmobarHook ps =
  dynamicLogWithPP
    xmobarPP
      { ppOutput = \x -> mapM_ (`hPutStrLn` x) ps,
        ppTitle = myTitlePP
      }

delayedSpawn :: String -> X ()
delayedSpawn c = spawn ("sleep 1 && " ++ c)

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
  -- set normal cursor, not the "X" one
  -- setDefaultCursor xC_left_ptr
  spawn "set_xcursor"
  -- FIXME
  delayedSpawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7\" eDP-1" -- set the touchscreen just to it's display
  delayedSpawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7\" eDP-1-1" -- set the touchscreen just to it's display
  -- Set any stylus input just to the touchscreen
  -- FIXME
  delayedSpawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7 Stylus Pen (0)\" eDP-1"
  delayedSpawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7 Stylus Pen (0)\" eDP-1-1"
  delayedSpawn "feh --bg-scale ~/.config/wallpaper.png"
  delayedSpawn "picom --config ~/.config/picom/picom.conf"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.

xmobarCommand :: Int -> String
xmobarCommand s = unwords ["xmobar", "-x", show s, "$HOME/.config/xmonad/xmobar/xmobarrc"]

main :: IO ()
main = do
  nScreens <- countScreens
  hs <- mapM (spawnPipe . xmobarCommand) [0 .. (nScreens - 1)]
  xmonad $
    ewmhFullscreen $
      ewmh $
        docks
          def
            { -- simple stuff
              terminal = myTerminal,
              focusFollowsMouse = myFocusFollowsMouse,
              clickJustFocuses = myClickJustFocuses,
              borderWidth = myBorderWidth,
              modMask = myModMask,
              workspaces = myWorkspaces,
              normalBorderColor = myNormalBorderColor,
              focusedBorderColor = myFocusedBorderColor,
              -- key bindings
              keys = myKeys,
              mouseBindings = myMouseBindings,
              -- hooks, layouts
              layoutHook = myLayout,
              manageHook = myManageHook,
              handleEventHook = myEventHook,
              -- logHook = xmobarHook [xmproc0, xmproc1],
              logHook = xmobarHook hs,
              startupHook = myStartupHook
            }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:",
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
      "mod-button3  Set the window to floating mode and resize by dragging"
    ]
