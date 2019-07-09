{-# LANGUAGE LambdaCase #-}
module Fu.Config
  ( getConfig
  , writeConfig
  , isNotLogged
  )
where

import           Control.Monad.IO.Class         ( liftIO )
import           Fu.Types
import           Data.Aeson              hiding ( (.=) )
import           Control.Lens                   ( view )
import           System.Directory               ( doesFileExist )

parseConfig :: IO (Maybe Config)
parseConfig = doesFileExist "~/fu.json" >>= \case
  True  -> decodeFileStrict "~/fu.json"
  False -> Nothing

getConfig :: FuContext (Maybe Config)
getConfig = liftIO parseConfig

writeConfig :: Config -> FuContext ()
writeConfig = liftIO . encodeFile "~/fu.json"

isNotLogged :: FuContext Bool
isNotLogged = not <$> view (config . logged)
