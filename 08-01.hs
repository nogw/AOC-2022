module Main (main) where

import Data.Char
import Data.List
import System.IO

readInput :: IO [String]
readInput = do 
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle 
    return $ lines contents

getTreeVisible :: [(Int, Int)] -> [(Int, Int)]
getTreeVisible = map last . filter (isTreeVisible . map snd) . tail . inits 

isTreeVisible :: [Int] -> Bool 
isTreeVisible ts = all (< hd) tl 
  where rev = reverse ts
        hd = head rev 
        tl = tail rev

getTreePairs :: [String] -> [[(Int, Int)]]
getTreePairs flines = [zip [n * len + 1 ..] ns | (n, ns) <- zip [1..] cnv]
  where len = length cnv 
        cnv = map (map digitToInt) flines

main :: IO ()
main = do 
    input <- readInput

    let is = getTreePairs input
    let ps = getPerms is 
    let vs = concatMap (concatMap getTreeVisible) ps
    let ys = nubBy (\(x, _) (y, _) -> x == y) vs

    print (length ys)
