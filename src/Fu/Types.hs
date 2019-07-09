{-# LANGUAGE TemplateHaskell, OverloadedStrings #-}
module Fu.Types
  ( CliOptions(..)
  , Command
  , UploadOptions(..)
  , Config(..)
  , Env(..)
  , config
  , filename
  , quiet
  , apiKey
  , name
  , logged
  , cliOptions
  , FuContext
  , Command(..)
  , command
  )
where

import           Control.Lens            hiding ( (.=) )
import           Control.Monad.Reader
import           Data.Aeson

data CliOptions = CliOptions
  { _command :: Command }

data Command
  = Login
  | Upload UploadOptions

data UploadOptions = UploadOptions
  { _filename :: FilePath
  , _quiet :: Bool }

data Config = Config
  { _apiKey :: String
  , _name :: String
  , _logged :: Bool }

instance FromJSON Config where
  parseJSON = withObject "Config" $ \ v -> Config
    <$> v .: "apiKey"
    <*> v .: "name"
    <*> v .: "logged"

instance ToJSON Config where
  toJSON (Config apiKey name logged) = object [ "apiKey" .= apiKey, "name" .= name, "logged" .= logged ]

data Env = Env
  { _cliOptions :: CliOptions
  , _config :: Config }

makeLenses ''UploadOptions
makeLenses ''CliOptions
makeLenses ''Env
makeLenses ''Config

type FuContext a = ReaderT Env IO a
