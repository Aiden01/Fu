{-# LANGUAGE LambdaCase #-}

module Fu.Logger
  ( error
  , warning
  , info
  , success
  )
where

import           Prelude                 hiding ( log
                                                , error
                                                )
import           Control.Monad.IO.Class         ( liftIO )
import           System.Console.ANSI
import           System.Console.ANSI.Types      ( Color )
import           Fu.Types
import           Fu.Utils
import           Control.Lens                   ( view )
import           Control.Monad                  ( when )

data Importance
  = Error
  | Warning
  | Info
  | Success

getColor :: Importance -> Color
getColor = \case
  Error   -> Red
  Warning -> Yellow
  Info    -> Blue
  Success -> Green

error, warning, info, success :: String -> FuContext ()
error = log Error

warning = log Warning

info = log Info

success = log Success

log :: Importance -> String -> FuContext ()
log i msg = do
  q <- view (uploadOpts . quiet)
  when (not q) (liftIO $ log' i msg)

log' :: Importance -> String -> IO ()
log' i msg = do
  setSGR [SetColor Foreground Vivid (getColor i)]
  putStrLn ("=> " <> msg)
  setSGR [Reset]
