module Main (main) where

import Data.Char
import Data.List ( tails, transpose, zipWith4 ) 
import System.IO

readInput :: IO [String]
readInput = do 
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle 
    return $ lines contents

organizeTrees :: [[a]] -> [[[a]]]
organizeTrees l = [x, l, z, y]
  where 
    x = map reverse l
    y = transpose l
    z = map reverse y

undoOrganizeTrees :: [[[a]]] -> [[[a]]]
undoOrganizeTrees [l, u, d] = [map reverse l, transpose $ map reverse u, transpose d]
undoOrganizeTrees _ = error "Cannot apply"

getInts :: [String] -> [[Int]]
getInts = map (map digitToInt)

getViewDists :: [Int] -> [Int]
getViewDists = map (`getIntViewDist` 0) . filter (not . null) . tails
  where 
    getIntViewDist :: [Int] -> Int -> Int
    getIntViewDist [_] n = n
    getIntViewDist (x:y:ys) n
      | y < x     = getIntViewDist (x:ys) (n + 1)
      | otherwise = n + 1
    getIntViewDist _ _ = error "Cannot apply"

main :: IO ()
main = do 
    input <- readInput

    let is = getInts input
    let [l1, r1, u1, d1] = map (map getViewDists) $ organizeTrees is
    let [l0, u0, d0] = undoOrganizeTrees [l1, u1, d1]
    let zs = zipWith4 (zipWith4 (\a b c d -> product [a, b, c, d])) l0 r1 u0 d0
    
    print (maximum $ concat zs)
