module Main (main) where

import Keys
import XMonad hiding (defaultConfig)
import XMonad.Prelude
import XMonad.Util.NamedActions

-- writeFile "keybindings" (unlines $ showKm x)
showKeybindings' :: [((KeyMask, KeySym), NamedAction)] -> IO ()
showKeybindings' x = do
  writeFile "keybindings" (unlines file)
  where
    file = map keyP x

keyP :: ((KeyMask, KeySym), NamedAction) -> String
keyP ((km, ks), action) = if ks == 0 then "" else keyToString (km, ks)

keybindings :: [((KeyMask, KeySym), NamedAction)]
keybindings = myKeys def

main :: IO ()
main = do
  putStrLn "Hello World"
  showKeybindings' keybindings
