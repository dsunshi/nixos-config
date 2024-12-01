import Bar
import Config
import Data.Map qualified as M
import Data.Monoid
import Keys
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ShowWName
import XMonad.Layout.IndependentScreens
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowArranger
import XMonad.Layout.WindowNavigation
import XMonad.StackSet qualified as W
import XMonad.Util.Hacks (fixSteamFlicker)
import XMonad.Util.NamedActions
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
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
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- setting colors for tabs layout and tabs sublayout.
myTabTheme =
  def
    { fontName = "",
      activeColor = "",
      inactiveColor = "",
      activeBorderColor = "",
      inactiveBorderColor = "",
      activeTextColor = "",
      inactiveTextColor = ""
    }

tall =
  renamed [Replace "tall"] $
    limitWindows 5 $
      smartBorders $
        windowNavigation $
          -- addTabs shrinkText myTabTheme $
          subLayout [] (smartBorders Simplest) $
            mySpacing 8 $
              ResizableTall 1 (3 / 100) (1 / 2) []

monocle =
  renamed [Replace "monocle"] $
    smartBorders $
      windowNavigation $
        -- addTabs shrinkText myTabTheme $
        subLayout
          []
          (smartBorders Simplest)
          Full

myLayoutHook = avoidStruts $ windowArrange myDefaultLayout
  where
    myDefaultLayout = withBorder myBorderWidth tall ||| noBorders monocle

-- myLayout =
--   let gapSize = 7
--    in gaps [(D, 40)] $
--         spacingRaw True (Border gapSize gapSize gapSize gapSize) True (Border gapSize gapSize gapSize gapSize) True $
--           tiled ||| Mirror tiled ||| Full
--   where
--     -- default tiling algorithm partitions the screen into two panes
--     tiled = Tall nmaster delta ratio
--
--     -- The default number of windows in the master pane
--     nmaster = 1
--
--     -- Default proportion of screen occupied by master pane
--     ratio = 1 / 2
--
--     -- Percent of screen to increment by when resizing panes
--     delta = 3 / 100

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
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook =
  composeAll
    [ className =? "Gimp" --> doFloat,
      className =? "Yad" --> doCenterFloat
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
    { swn_font = "xft:Iosevka:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#1F1F28",
      swn_color = "#DCD7BA"
    }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
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
