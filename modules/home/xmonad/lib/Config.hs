module Config
  ( myTerminal,
    myModMask,
    myWorkspaces,
    myFocusFollowsMouse,
    myClickJustFocuses,
    myBorderWidth,
    myNormalBorderColor,
    myFocusedBorderColor,
    myXPConfig,
  )
where

import XMonad
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch (fuzzyMatch)

myTerminal :: String
myTerminal = "kitty"

myModMask :: KeyMask
myModMask = mod4Mask

myWorkspaces :: [String]
myWorkspaces = map show [1 .. 9]

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth = 2

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor :: String
myNormalBorderColor = "#1F1F28"

myFocusedBorderColor :: String
myFocusedBorderColor = "#B9B4D0"

myFont :: String
myFont = "xft:iosevka:size=14:hinting=0:antialias=1"

myBgColor :: String
myBgColor = "#1F1F28"

myDefaultColor :: String
myDefaultColor = "#DCD7BA"

myXPConfig :: XPConfig
myXPConfig =
  def
    { font = myFont,
      bgColor = myBgColor,
      fgColor = myDefaultColor,
      bgHLight = myBgColor,
      fgHLight = myFocusedBorderColor,
      borderColor = myNormalBorderColor,
      promptBorderWidth = 1,
      height = 32,
      position = Top,
      historySize = 1000,
      historyFilter = deleteConsecutive,
      searchPredicate = fuzzyMatch
      --    , autoComplete        = Nothing
    }