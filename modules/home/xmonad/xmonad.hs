import Data.List
import Data.Map qualified as M
import GHC.IO.Handle
import Keys
import Prompt.Eval
import System.Exit
import Text.Printf
import XMonad
import XMonad.Actions.WorkspaceNames
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ShowWName
import XMonad.Layout.Gaps
import XMonad.Layout.IndependentScreens
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch (fuzzyMatch)
import XMonad.StackSet qualified as W
import XMonad.Util.Cursor
import XMonad.Util.NamedActions
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

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme =
  def
    { swn_font = "xft:Ioseveka:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#1F1F28",
      swn_color = "#DCD7BA"
    }

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

-- FIXME: Needed?
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
  delayedSpawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7\" eDP-1-1" -- set the touchscreen just to it's display
  -- Set any stylus input just to the touchscreen
  delayedSpawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7 Stylus Pen (0)\" eDP-1-1"
  delayedSpawn "feh --bg-scale --no-fehbg ~/.config/wallpaper.png"
  delayedSpawn "picom --config ~/.config/picom/picom.conf"
  -- set cursor from cursor.nix, not the "X" one
  delayedSpawn "set_xcursor"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.

xmobarCommand :: Int -> String
xmobarCommand s = unwords ["xmobar", "-x", show s, "$HOME/.config/xmonad/xmobar/xmobarrc"]

main :: IO ()
main = do
  nScreens <- countScreens
  hs <- mapM (spawnPipe . xmobarCommand) [0 .. (nScreens - 1)]
  xmonad $ -- M-<F1> to show key bindings
    addDescrKeys' ((myModMask, xK_F1), showKeybindings) myKeys $
      ewmhFullscreen $
        ewmh $
          docks
            def
              { terminal = myTerminal,
                focusFollowsMouse = myFocusFollowsMouse,
                clickJustFocuses = myClickJustFocuses,
                borderWidth = myBorderWidth,
                modMask = myModMask,
                workspaces = myWorkspaces,
                normalBorderColor = myNormalBorderColor,
                focusedBorderColor = myFocusedBorderColor,
                mouseBindings = myMouseBindings,
                layoutHook = showWName' myShowWNameTheme myLayout,
                manageHook = myManageHook,
                handleEventHook = myEventHook,
                logHook = xmobarHook hs,
                startupHook = myStartupHook
              }
