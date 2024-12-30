import Bar
import Config
import Keys
import Layouts
import Mouse
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.IndependentScreens
import XMonad.Layout.ShowWName
import XMonad.Util.Hacks (fixSteamFlicker)
import XMonad.Util.NamedActions
import XMonad.Util.Run

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
  -- spawn "feh --bg-scale --no-fehbg ~/.config/wallpaper.png"
  spawn "walk-bandit"
  spawn "picom --config ~/.config/picom/picom.conf"
  -- set cursor from cursor.nix, not the "X" one
  spawn "set_xcursor"

------------------------------------------------------------------------
-- main
-- TODO: https://stackoverflow.com/questions/65146632/xmonad-how-to-show-the-currently-visible-workspace-on-xmobar-when-using-multipl
-- https://hackage.haskell.org/package/xmonad-contrib-0.18.1/docs/XMonad-Layout-IndependentScreens.html
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
