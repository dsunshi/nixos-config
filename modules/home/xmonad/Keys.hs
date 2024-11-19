module Keys () where

import XMonad
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions

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
switchWorkspaces = foldl (<>) [] $ map switchWorkspaceCommand [0 .. 9]

sendWorkspaceCommand :: Int -> [(String, NamedAction)]
sendWorkspaceCommand id = [(key, addName description $ windows $ W.shift $ show id)]
  where
    key = "M-S-" ++ show id
    description = "Send to workspace " ++ show id

sendWorkspaces :: [(String, NamedAction)]
sendWorkspaces = foldl (<>) [] $ map sendWorkspaceCommand [0 .. 9]
