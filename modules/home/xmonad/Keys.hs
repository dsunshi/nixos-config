module Keys (myKeys, myHelpKey, showKeybindings) where

import Config
import Prompt.Eval
import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves
import XMonad.Actions.WithAll
import XMonad.Hooks.ManageDocks
import XMonad.Layout.ResizableThreeColumns
import XMonad.Layout.ToggleLayouts qualified as T
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions
import XMonad.Util.Run

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  -- FIXME: what to use instead of yad?
  h <- spawnPipe "yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 12\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
  -- hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

-- Keycode to run `showKeybindings`
myHelpKey :: (KeyMask, KeySym)
myHelpKey = (myModMask, xK_F1)

--       -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
--       -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
--       --
--       [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
--         | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..],
--           (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
--       ]
myKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
  subKeys
    "XMonad Essentials"
    [ ("M-q", addName "Restart XMonad" $ spawn "xmonad --recompile; xmonad --restart"),
      ("M-S-q", addName "Quit XMonad" $ spawn "rofi -show power-menu -modi power-menu:rofi-power-menu"),
      ("M-S-c", addName "Kill focused window" kill),
      ("M-p", addName "Run application launcher" $ spawn "rofi -show drun"),
      ("M-S-p", addName "Run Haskell prompt" $ evalPrompt myXPConfig),
      ("M-S-<Return>", addName "Launch a terminal" $ spawn myTerminal),
      ("M-S-b", addName "Toggle bar show/hide" $ sendMessage ToggleStruts)
    ]
    ^++^ subKeys
      "Switch to Workspace"
      (foldCmd switch) -- M-# -> Switch to workspace #
    ^++^ subKeys
      "Send Window to Workspace"
      (foldCmd send) -- M-S-# -> Send window to workspace #
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
      "Switch layouts"
      [("M-<Tab>", addName "Switch to next layout" $ sendMessage NextLayout)]
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

------------------------------------------------------------------------
-- Functions to generate keybindings for switching and sending windows
-- based on `myWorkspaces`.

type WsCmd = ([String] -> Int -> [(String, NamedAction)])

switch :: WsCmd
switch ws id = [(key, addName description $ windows $ W.greedyView $ ws !! (id - 1))]
  where
    key = "M-" ++ show id
    description = "Switch to workspace " ++ show id

send :: WsCmd
send ws id = [(key, addName description $ windows $ W.shift $ ws !! (id - 1))]
  where
    key = "M-S-" ++ show id
    description = "Send to workspace " ++ show id

foldCmd :: WsCmd -> [(String, NamedAction)]
foldCmd = foldCmd' myWorkspaces

foldCmd' :: [String] -> WsCmd -> [(String, NamedAction)]
foldCmd' ws cmd = foldl (<>) [] $ map (cmd ws) [0 .. length ws - 1]
