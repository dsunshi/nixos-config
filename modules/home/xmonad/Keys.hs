module Keys (myKeys, showKeybindings) where

import System.IO
import XMonad
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions
import XMonad.Util.Run

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe "yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 12\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
  -- hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

--       -- launch Haskell prompt
--       ((modm .|. shiftMask, xK_p), evalPrompt myXPConfig),
--     -- launch a terminal
--     [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
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
      ("M-p", addName "Run application launcher" $ spawn "rofi -show drun")
    ]
    ^++^ subKeys
      "Switch to Workspace"
      switchWorkspaces -- M-# -> Switch to workspace #
    ^++^ subKeys
      "Send Window to Workspace"
      sendWorkspaces -- M-S-# -> Send window to workspace #
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

-- TODO: Ezconfig
-- https://hackage.haskell.org/package/xmonad-contrib-0.18.1/docs/XMonad-Util-EZConfig.html
-- https://www.youtube.com/watch?v=gPQ9mn9Nkpc @ 27:32
-- https://github.com/vonabarak/xmonad-config/blob/master/src/Keys.hs

switchWorkspaceCommand :: Int -> [(String, NamedAction)]
switchWorkspaceCommand id = [(key, addName description $ windows $ W.greedyView $ show id)]
  where
    key = "M-" ++ show id
    description = "Switch to workspace " ++ show id

switchWorkspaces :: [(String, NamedAction)]
switchWorkspaces = foldl (<>) [] $ map switchWorkspaceCommand [1 .. 9]

sendWorkspaceCommand :: Int -> [(String, NamedAction)]
sendWorkspaceCommand id = [(key, addName description $ windows $ W.shift $ show id)]
  where
    key = "M-S-" ++ show id
    description = "Send to workspace " ++ show id

sendWorkspaces :: [(String, NamedAction)]
sendWorkspaces = foldl (<>) [] $ map sendWorkspaceCommand [1 .. 9]
