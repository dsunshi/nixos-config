module Prompt.Eval (evalPrompt) where

import Data.List (intercalate)
import Language.Haskell.Interpreter qualified as I
import XMonad
import XMonad.Prompt
  ( XPConfig,
    XPrompt (commandToComplete, showXPrompt),
    mkXPrompt,
  )

-- Eval prompt.
-- evaluate any haskell expression
data EvalPrompt = EvalPrompt

instance XPrompt EvalPrompt where
  showXPrompt EvalPrompt = "λ> "
  commandToComplete _ = id

evalComplFunction :: (MonadIO m) => String -> m [String]
evalComplFunction s = io $ do
  res <- I.runInterpreter $ do
    I.setImports ["Prelude"]
    I.eval s
  case res of
    Left err -> return [show err]
    Right result -> return (lines result)

showResult :: (MonadIO m) => String -> m ()
showResult s = io $ do
  result <- evalComplFunction s
  spawn $ "notify-send \"" ++ intercalate "\n" result ++ "\""

evalPrompt :: XPConfig -> X ()
evalPrompt myXPConfig = do
  uninstallSignalHandlers
  mkXPrompt EvalPrompt myXPConfig evalComplFunction showResult
  installSignalHandlers
