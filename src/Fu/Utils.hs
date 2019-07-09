module Fu.Utils
  ( uploadOpts
  )
where

import           Control.Lens
import           Fu.Types

uploadOpts :: Lens' Env UploadOptions
uploadOpts = lens getter setter
 where
  getter :: Env -> UploadOptions
  getter s = let (Upload opts) = s ^. cliOptions . command in opts
  setter :: Env -> UploadOptions -> Env
  setter s opts = s & (cliOptions . command) .~ (Upload opts)
