{-# LANGUAGE LambdaCase #-}

module Fu.App
  ( startApp
  )
where


import           Control.Lens
import           Fu.Types
import qualified Fu.Logger                     as L
import           Fu.Config                      ( getConfig
                                                , isNotLogged
                                                , writeConfig
                                                )
import           Control.Monad.Reader
import           Fu.Utils
import           System.IO
import           System.Console.ANSI

prompt :: String -> IO String
prompt text = do
  setSGR [SetColor Foreground Vivid Blue]
  putStr text
  setSGR [Reset]
  hFlush stdout
  getLine


startApp :: FuContext ()
startApp = getConfig >>= \case
  Just conf -> local (config .~ conf) processCommand
  Nothing   -> L.error "Cannot parse config file"

processCommand :: FuContext ()
processCommand = view (cliOptions . command) >>= \case
  Upload _ -> upload
  Login    -> login

upload :: FuContext ()
upload = isNotLogged >>= \case
  True  -> L.info "You are not logged. Type fu login to login"
  False -> do
    file <- view (uploadOpts . filename)
    L.info "Uploading file..."

login :: FuContext ()
login = do
  newName   <- liftIO $ prompt "=> Name: "
  newApiKey <- liftIO $ prompt "=> Api key: "
  oldConfig <- view config
  let newConfig =
        oldConfig & name .~ newName & apiKey .~ newApiKey & logged .~ True
  writeConfig newConfig
  L.error "Logged in!"
