import Bar
import Config
-- import Data.Map qualified as M
-- import Data.Monoid
import Keys
import Layouts
import Mouse
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
-- import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ShowWName
import XMonad.Layout.IndependentScreens
-- import XMonad.Layout.LayoutModifier
-- import XMonad.Layout.LimitWindows
-- import XMonad.Layout.NoBorders
-- import XMonad.Layout.Renamed
-- import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
-- import XMonad.Layout.Simplest
-- import XMonad.Layout.Spacing
-- import XMonad.Layout.SubLayouts
-- import XMonad.Layout.Tabbed
-- import XMonad.Layout.WindowArranger
-- import XMonad.Layout.WindowNavigation
-- import XMonad.StackSet qualified as W
import XMonad.Util.Hacks (fixSteamFlicker)
import XMonad.Util.NamedActions
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

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
    { swn_font = "xft:Iosevka:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#1F1F28",
      swn_color = "#DCD7BA"
    }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook :: X ()
myStartupHook = do
  -- set the touchscreen just to it's display
  spawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7\" eDP-1-1"
  -- Set any stylus input just to the touchscreen
  spawn "xinput --map-to-output \"ELAN9008:00 04F3:2ED7 Stylus Pen (0)\" eDP-1-1"
  spawn "feh --bg-scale --no-fehbg ~/.config/wallpaper.png"
  spawnOnce "picom --config ~/.config/picom/picom.conf"
  -- set cursor from cursor.nix, not the "X" one
  spawn "set_xcursor"

------------------------------------------------------------------------
-- main

xmobarCommand :: Int -> String
xmobarCommand s = unwords ["xmobar", "-x", show s, "$HOME/.config/xmonad/xmobar/xmobarrc"]

main :: IO ()
main = do
  nScreens <- countScreens
  hs <- mapM (spawnPipe . xmobarCommand) [0 .. (nScreens - 1)]
  xmonad $
    addDescrKeys' (myHelpKey, showKeybindings) myKeys $
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
                layoutHook = showWName' myShowWNameTheme myLayoutHook,
                manageHook = myManageHook,
                handleEventHook = fixSteamFlicker <+> myEventHook,
                logHook = xmobarHook hs,
                startupHook = myStartupHook
              }
