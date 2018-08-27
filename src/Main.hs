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

print_folder_options configFolders = do
  traceM ("calling print_folder_options " ++ show ("ccc",configFolders))
  return 1

apply_option configFolders = do
  traceM ("calling apply_option " ++ show ("ccc",configFolders))
  return 1

check_if_proceed configFolders = do
  let emacsdf = "/home/jacek/.emacs.d"
  traceM ("calling check_if_proceed " ++ show ("ccc",configFolders))
  exists <- doesDirectoryExist emacsdf
  symlink <- pathIsSymbolicLink emacsdf
  let confemp = configFolders == []
  let result = do
        if exists
          then do
            if symlink
              then do
                symlTarget <- getSymbolicLinkTarget emacsdf
                putStrLn ("This action will overwrite the existing symlink\n"++
                          "pointing to " ++ (show symlTarget) ++"\n\n" )
                return 2
              else do
                putStrLn (emacsdf ++ " is not a symlink\n"++
                          "to use this utility, in your terminal do something like:\n"++
                          "$ mv " ++ emacsdf ++ " " ++ emacsdf ++ "-alternative-config\n" ++
                          "exiting..." )
                return 0
          else do
            putStrLn ("no " ++ emacsdf ++ "found in your home folder")
            if confemp
              then do
                putStrLn ("nor folders with the alternative emacs config\n" ++
                          "exiting..." )
                return 0
              else do
                putStrLn "will try to symlink one of the found folders"
                return 2
  if (confemp)
    then do
      putStrLn  "No alternative config folders found, exiting..."
      return 0
    else do
      putStrLn "Final else"
      return 1


main = do
  hl <- homeList
  let configFolders = emacsFolderEntries hl
  putStrLn (show configFolders)
  proceed <- check_if_proceed configFolders
  if (proceed == 1)
    then do
      putStrLn "going to do then "
      print_folder_options configFolders
      apply_option configFolders
      return ()
    else do
      putStrLn "not going anything"
      return ()
