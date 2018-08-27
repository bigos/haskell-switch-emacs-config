module Main where

import Debug.Trace
import System.IO
import System.Directory
-- import System.FilePath
import Data.String.Utils
import Control.Monad

data Jabool = Jatrue | Jafalse | Jaundecided deriving (Eq, Read, Show)

homeList :: IO [FilePath]
homeList = listDirectory "/home/jacek/"

emacsd :: String
emacsd = ".emacs.d"

default_config_folder = "/home/jacek/.emacs.d"

emacsFolderEntries :: [String] -> [String]
emacsFolderEntries hl = filter (\f -> startswith (emacsd++"-") f) hl

input :: String -> IO String
input prompt = do
  putStr prompt
  putStr " > "
  getLine

print_folder_options configFolders = do
  -- traceM ("calling print_folder_options " ++ show ("ccc",configFolders))
  putStrLn "Select emacs config number"
  mapM (\x-> putStrLn $(show x) ++ " - " ++ configFolders!!x) [ 0 .. (pred (length configFolders))]
  return ()

apply_option configFolders = do
  -- traceM ("calling apply_option " ++ show ("ccc",configFolders))
  opt' <- input "Option"
  let opt = (read opt') :: Int
  let optf = configFolders!!opt
  putStrLn $ show optf
  fex <- (doesDirectoryExist default_config_folder)
  if fex
    then do
      putStrLn "removing folder"
      removeFile default_config_folder
    else do
      putStrLn ("not doing anything " ++ (show fex))
      return ()
  createDirectoryLink optf default_config_folder
  putStrLn "created symlink"
  return 1

check_if_proceed configFolders = do
  let emacsdf = "/home/jacek/.emacs.d"
  -- traceM ("calling check_if_proceed " ++ show ("ccc",configFolders))
  exists <- doesDirectoryExist emacsdf
  let confemp = configFolders == []
  result <- do
    if exists
      then do
      {
        symlink <- pathIsSymbolicLink emacsdf ;
        if symlink
        then do
          {
            symlTarget <- getSymbolicLinkTarget emacsdf ;
            putStrLn ("This action will overwrite the existing symlink\n"++
                      "pointing to " ++ (show symlTarget) ++"\n\n" ) ;
            return Jaundecided
          }
        else do
          {
            putStrLn (emacsdf ++ " is not a symlink\n"++
                      "to use this utility, in your terminal do something like:\n"++
                      "$ mv " ++ emacsdf ++ " " ++ emacsdf ++ "-alternative-config\n" ++
                      "exiting..." ) ;
            return Jafalse
          }
      }
      else do
      {
        putStrLn ("no " ++ emacsdf ++ " found in your home folder") ;
        if confemp
        then do
          {
            putStrLn ("nor folders with the alternative emacs config\n" ++
                      "exiting..." ) ;
            return Jafalse
          }
        else do
          {
            putStrLn "will try to symlink one of the found folders" ;
            return Jaundecided
          }
      }

  if (result == Jaundecided)
    then do
      if confemp
      then do
          putStrLn  "No alternative config folders found, exiting..." ;
          return Jafalse
      else do
          return Jatrue
    else do
      putStrLn $ show result ;
      return result

main = do
  hl <- homeList
  let configFolders = emacsFolderEntries hl
  -- putStrLn (show configFolders)
  proceed <- check_if_proceed configFolders
  if (proceed == Jatrue)
    then do
      -- putStrLn "going to do then "
      print_folder_options configFolders
      apply_option configFolders
      return ()
    else do
      putStrLn "not doing anything"
      return ()
