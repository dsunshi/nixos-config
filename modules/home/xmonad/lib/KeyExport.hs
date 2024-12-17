module Main (main) where

import Keys
import XMonad hiding (defaultConfig)
import XMonad.Util.NamedActions

showKeybindings' :: [((KeyMask, KeySym), NamedAction)] -> IO ()
showKeybindings' x = do
  writeFile "keybindings" (unlines $ showKmSimple x)

keybindings :: [((KeyMask, KeySym), NamedAction)]
keybindings = myKeys def

main :: IO ()
main = do
  putStrLn "Hello World"
  showKeybindings' keybindings
