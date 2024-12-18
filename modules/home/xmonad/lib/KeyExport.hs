module Main (main) where

import Data.List.Split
import Keys
import Text.Printf
import XMonad hiding (defaultConfig)
import XMonad.Prelude
import XMonad.Util.NamedActions

mod :: KeyMask -> String
mod 0 = ""
mod 8 = "$mod"
mod 9 = "$mod SHIFT"

letter :: (KeyMask, KeySym) -> String
letter (km, ks) = last parts
  where
    parts = splitOn "-" str
    str = keyToString (km, ks)

-- "$mod, F, exec, firefox"
-- "$mod, k, exec, kitty"
-- "$mod SHIFT, Return, exec, kitty"
-- table :: [((KeyMask, KeySym), String)]
-- writeFile "keybindings" (unlines $ showKm x)
showKeybindings' :: [((KeyMask, KeySym), NamedAction)] -> IO ()
showKeybindings' x = do
  writeFile "keybindings" (unlines file)
  where
    file = map keyP x

keyP :: ((KeyMask, KeySym), NamedAction) -> String
keyP ((km, ks), action) = if ks == 0 then "" else printf "(%s, %s): %s" (show km) (show ks) (keyToString (km, ks))

keybindings :: [((KeyMask, KeySym), NamedAction)]
keybindings = myKeys def

main :: IO ()
main = do
  putStrLn "Hello World"
  showKeybindings' keybindings
