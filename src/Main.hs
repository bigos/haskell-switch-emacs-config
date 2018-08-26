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
  let confemp = configFolders == []
  let result = False
  if exists
    then do
    {
      if symlink
      then do
        {
          putStrLn ("This action will overwrite the existing symlink\n"++
                    "poinitng to " ++ "SOMEWHERE-FINISH ME\n\n" )
        }
      else do
        {
          putStrLn (emacsdf ++ " is not a symlink\n"++
                    "to use this utility, in your terminal do soemthing like:\n"++
                    "$ mv " ++ emacsdf ++ " " ++ emacsdf ++ "-alternative-config\n" ++
                    "exiting..." )
        }
    }
    else do
    {
      putStrLn ("no " ++ emacsdf ++ "found in your home folder")
      if confemp
      then do
        {
          putStrLn ("nor folders with the alternative emacs config\n" ++
                    "exiting..." )

        }
      else
        do {
          putStrLn "will try to symlink one of the found folders"
          }
    }



  putStrLn $ show (emacsd, exists, symlink, confemp, result)
  let result = result


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
