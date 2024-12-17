module Main (main) where

import Keys
import System.IO
import XMonad
import XMonad.Util.NamedActions
import XMonad.Util.Run

showKeybindings' :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings' x = addName "Show Keybindings" $ io $ do
  h <-
    spawnPipe
      "yad --text-info --fontname=\"Iosevka 12\" --fore=#DCD7BA --back=#1F1F28\
      \ --center --geometry=1200x800 --title \"XMonad keybindings\""
  hPutStr h (unlines $ showKmSimple x)
  hClose h
  return ()

result = addDescrKeys' (myHelpKey, showKeybindings') myKeys

main :: IO ()
main = putStrLn "Hello World"
