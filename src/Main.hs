module Main where

import Debug.Trace
import System.IO
import System.Directory
-- import System.FilePath
import Data.String.Utils
import Control.Monad

homeList :: IO [FilePath]
homeList = listDirectory "/home/jacek/"

emacsd :: String
emacsd = ".emacs.d"

default_config_folder = "/home/jacek/.emacs.d"

emacsFolderEntries :: [String] -> [String]
emacsFolderEntries hl = filter (\f -> startswith emacsd f) hl

print_folder_options configFolders = undefined

apply_option configFolders = undefined

mainThen configFolders = do
    print_folder_options configFolders
    apply_option configFolders
    return ()


check_if_proceed configFolders = do
  let emacsdf = "/home/jacek/.emacs.d"
  traceM ("calling check_if_proceed " ++ show ("ccc",configFolders))
  exists <- doesDirectoryExist emacsdf
  symlink <- pathIsSymbolicLink emacsdf

  -- if exists
  --   then
  --   if symlink
  --   then 1
  --   else 2
  --   else
  --   3
  putStrLn $ show (emacsd, exists, symlink)


main :: IO ()
main = do
  hl <- homeList
  let configFolders = emacsFolderEntries hl
  putStrLn (show configFolders)
  proceed <- check_if_proceed configFolders
  putStrLn (show proceed)
  return ()
  -- if proceed
  --   then mainThen configFolders
  --   else return ()
