module Fu.Cli
  ( runCli
  )
where

import           Options.Applicative
import           Data.Semigroup                 ( (<>) )
import           Fu.App                         ( startApp )
import           Fu.Types                hiding ( command )
import           Control.Monad.Reader

uploadParser :: Parser UploadOptions
uploadParser =
  UploadOptions
    <$> argument str (metavar "FILENAME" <> help "File to upload")
    <*> switch (long "quiet" <> short 'q' <> help "Whether to be quiet")

commandParser :: Parser Command
commandParser = subparser
  (  command "upload"
             (info (Upload <$> uploadParser) (progDesc "Upload a file to Mega"))
  <> command "login" (info (pure Login) (progDesc "Login to Mega"))
  )

cliParser :: Parser CliOptions
cliParser = CliOptions <$> commandParser

runCli :: IO ()
runCli = runApp =<< execParser headerParser
 where
  headerParser = info
    (cliParser <**> helper)
    (fullDesc <> progDesc "Upload file to Mega using the command line" <> header
      "Mega CLI written in Haskell"
    )

createContext :: CliOptions -> Env
createContext opts = Env
  { _cliOptions = opts
  , _config     = Config {_apiKey = "", _name = "", _logged = False}
  }

runApp :: CliOptions -> IO ()
runApp = runReaderT startApp . createContext
