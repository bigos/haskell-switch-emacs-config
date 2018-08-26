module Main where

import System.IO
import System.Directory
-- import System.FilePath
import Data.String.Utils
import Control.Monad

-- printHomeFiles = homeList >>=
--   (\fl ->
--      mapM_ (\s ->
--              if (startswith emacsd s)
--              then (putStrLn s)
--              else (putStr "")
--              )
--      fl)

-- pseudoFiles = do
--   fs <- homeList
--   let ems = (filter (\f -> startswith emacsd f) fs)
--   putStrLn (show ems)

-- pseudoFiles2 = homeList >>=
--   (\fs -> putStrLn $ show $ ems fs)
--   where ems fs = (filter (\f -> startswith emacsd f) fs)

-- filterPrefixed :: [String] -> [String]
-- filterPrefixed as = filter (\s -> startswith emacsd s) as


-- prompt :: String -> IO String
-- prompt str = putStr (str ++ " ") >> hFlush stdout >> getLine

-- initBuffering :: IO ()
-- initBuffering = mapM_ (\h -> hSetBuffering h LineBuffering) [stdin, stdout]

-- printFirstHalfOfSingleString :: String -> IO ()
-- printFirstHalfOfSingleString s = putStrLn (take (length s `div` 2) s)

-- printFirstHalfOfEachString :: [String] -> IO ()
-- printFirstHalfOfEachString = mapM_ printFirstHalfOfSingleString

-- namify = listDirectory "." >>= printFirstHalfOfEachString
-- homify = homeList >>= printFirstHalfOfEachString

-- pattern' = (emacsd++"-")

--emacsFolderEntries = filter (\fn -> startswith fn pattern' fn) homeList

homeList :: IO [FilePath]
homeList = listDirectory "/home/jacek/"

emacsd :: String
emacsd = ".emacs.d"

emacsFolderEntries hl = filter (\f -> startswith emacsd f) hl

print_folder_options configFolders = undefined

apply_option configFolders = undefined

mainThen configFolders = do
    print_folder_options configFolders
    apply_option configFolders
    return ()

check_if_proceed :: a -> Bool
check_if_proceed configFolders = undefined

main :: IO ()
main = do
  hl <- homeList
  let configFolders = emacsFolderEntries hl
  putStrLn (show configFolders)
  let proceed = check_if_proceed configFolders
  if proceed
    then mainThen configFolders
    else return ()
