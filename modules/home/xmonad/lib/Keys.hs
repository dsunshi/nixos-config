module Keys (myKeys, myHelpKey, showKeybindings) where

import Config
import Control.Monad
import Prompt.Eval
import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves
import XMonad.Actions.WithAll
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ShowWName
import XMonad.Layout.IndependentScreens
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.ResizableThreeColumns
import XMonad.Layout.ToggleLayouts qualified as T
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions
import XMonad.Util.Run

-- Keycode to run `showKeybindings`, i.e. display help
myHelpKey :: (KeyMask, KeySym)
myHelpKey = (myModMask .|. shiftMask, xK_h)

showScreens :: X ()
showScreens = do
  nScreens <- countScreens
  replicateM_ nScreens showThenNext
  where
    showThenNext = do
      flashName myShowWNameTheme
      nextScreen
      spawn "sleep 0.1"

myKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
  let fullscreen = do
        sendMessage $ JumpToLayout monocoleN
        sendMessage ToggleStruts
   in subKeys
        "XMonad Essentials"
        [ ("M-q", addName "Restart XMonad" $ spawn "xmonad --recompile; xmonad --restart"),
          ("M-S-q", addName "Quit XMonad" $ spawn "rofi -show power-menu -modi power-menu:rofi-power-menu"),
          ("M-S-c", addName "Kill focused window" kill),
          ("M-p", addName "Run application launcher" $ spawn "rofi -show drun"),
          ("M-S-p", addName "Run Haskell prompt" $ evalPrompt myXPConfig),
          ("M-S-<Return>", addName "Launch a terminal" $ spawn myTerminal),
          -- ("M-w", addName "Display current workspace name" $ flashName myShowWNameTheme),
          ("M-w", addName "Display current workspace name on each screen" showScreens),
          ("M-S-b", addName "Toggle bar show/hide" $ sendMessage ToggleStruts)
        ]
        ^++^ subKeys
          "Switch to Workspace"
          (foldWs switch myWorkspaces) -- M-# -> Switch to workspace #
        ^++^ subKeys
          "Send Window to Workspace"
          (foldWs send myWorkspaces) -- M-S-# -> Send window to workspace #
        ^++^ subKeys
          "Window Navigation"
          [ ("M-<Down>", addName "Move focus to next window" $ windows W.focusDown),
            ("M-<Up>", addName "Move focus to prev window" $ windows W.focusUp),
            ("M-m", addName "Move focus to master window" $ windows W.focusMaster),
            ("M-S-<Down>", addName "Swap focused window with next window" $ windows W.swapDown),
            ("M-S-<Up>", addName "Swap focused window with prev window" $ windows W.swapUp),
            ("M-S-m", addName "Swap focused window with master window" $ windows W.swapMaster),
            ("M-<Backspace>", addName "Move focused window to master" promote),
            ("M-S-,", addName "Rotate all windows except master" rotSlavesDown),
            ("M-S-.", addName "Rotate all windows current stack" rotAllDown)
          ]
        ^++^ subKeys
          "Monitors"
          [ ("M-.", addName "Switch focus to next monitor" nextScreen),
            ("M-,", addName "Switch focus to prev monitor" prevScreen)
          ]
        ^++^ subKeys
          "Bandit"
          [ ("M-b 1", addName "Take Bandit for a walk" $ spawn "walk-bandit 1"),
            ("M-b 2", addName "Take Bandit for a walk" $ spawn "walk-bandit 2"),
            ("M-b 3", addName "Take Bandit for a walk" $ spawn "walk-bandit 3"),
            ("M-b 4", addName "Take Bandit for a walk" $ spawn "walk-bandit 4")
          ]
        ^++^ subKeys
          "Switch layouts"
          [ ("M-<Tab>", addName "Switch to next layout" $ sendMessage NextLayout),
            ("M-n", addName "Switch to fullscreen (devel)" fullscreen)
          ]
        ^++^ subKeys
          "Window resizing"
          [ ("M-h", addName "Shrink window" $ sendMessage Shrink),
            ("M-l", addName "Expand window" $ sendMessage Expand),
            ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink),
            ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)
          ]
        ^++^ subKeys
          "Floating windows"
          [ ("M-f", addName "Toggle float layout" $ sendMessage (T.Toggle "floats")),
            ("M-t", addName "Sink a floating window" $ withFocused $ windows . W.sink),
            ("M-S-t", addName "Sink all floated windows" sinkAll)
          ]
        ^++^ subKeys
          "Multimedia Keys"
          [ ("<F2>", addName "Lower volume by 5%" $ spawn "pamixer -d 5"),
            ("<F3>", addName "Raise volume by 5%" $ spawn "pamixer -i 5"),
            ("<F7>", addName "Lower screen brightness by 5%" $ spawn "brightnessctl set 5%- -d intel_backlight"),
            ("<F8>", addName "Raise screen brightness by 5%" $ spawn "brightnessctl set 5%+ -d intel_backlight")
          ]
        ^++^ subKeys
          "Keyboard Layout"
          [ ("M-z", addName "Switch to Colemak mod-DH ortho layout" $ spawn "setxkbmap -layout us -variant colemak_dh_ortho"),
            ("M-S-z", addName "Switch to QWERTY layout" $ spawn "setxkbmap -layout us")
          ]
  where
    subKeys str ks = subtitle str : mkNamedKeymap c ks

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <-
    spawnPipe
      "yad --text-info --fontname=\"Iosevka 12\" --fore=#DCD7BA --back=#1F1F28\
      \ --center --geometry=1200x800 --title \"XMonad keybindings\""
  hPutStr h (unlines $ showKmSimple x)
  hClose h
  return ()

------------------------------------------------------------------------
-- Functions to generate keybindings for switching and sending windows
-- based on a [String] of workspace names.

type WsCmd = ([String] -> Int -> [(String, NamedAction)])

switch :: WsCmd
switch = move "M-" "Switch to workspace " W.greedyView

send :: WsCmd
send = move "M-S-" "Send to Workspace " W.shift

move :: String -> String -> (String -> WindowSet -> WindowSet) -> [String] -> Int -> [(String, NamedAction)]
move k d stackCmd ws id = [(key, addName description $ windows $ stackCmd wsName)]
  where
    wsName = ws !! id
    key = k ++ show (id + 1)
    description = d ++ wsName

foldWs :: WsCmd -> [String] -> [(String, NamedAction)]
foldWs cmd ws = foldl (<>) [] $ map (cmd ws) [0 .. length ws - 1]
