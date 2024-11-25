module Bar (xmobarHook) where

import Data.List
import GHC.IO.Handle
import System.IO
import XMonad
import XMonad.Hooks.DynamicLog

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.

titleFox :: String -> String
titleFox t = if isFirefox t then justFirefox else t
  where
    isFirefox = isInfixOf justFirefox
    justFirefox = "Mozilla Firefox"

xmobarHook :: [Handle] -> X ()
xmobarHook ps =
  dynamicLogWithPP
    xmobarPP
      { ppOutput = \x -> mapM_ (`hPutStrLn` x) ps,
        -- Title of active window
        ppTitle = xmobarColor "#5E5086" "" . shorten 60,
        -- escape / sanitizes input to ppTitle
        ppTitleSanitize = titleFox,
        -- Active workspace
        ppCurrent = xmobarColor "#8EA4A2" "" . wrap "<box type=VBoth width=1 color=#C4746E>" "</box>",
        -- Visible but not current workspace
        ppVisible = xmobarColor "#54546D" "",
        -- Hidden workspace
        ppHidden = xmobarColor "#363646" "",
        -- Hidden workspaces (no windows)
        ppHiddenNoWindows = xmobarColor "#2A2A37" "",
        -- separator to use between different log sections (window name, layout, workspaces)
        ppSep = " \58913 "
      }
