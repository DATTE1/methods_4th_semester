import Distribution.Compat.CharParsing (CharParsing(string))
import Text.XHtml (sub)
import System.IO
import Data.List (intercalate, minimumBy, isInfixOf)
import Data.Char (isAlpha)
import qualified Data.Set as Set
import Data.Ord (comparing)
import Data.Function
main :: IO ()

foo :: Int -> Int -> Float
foo = (/) `on` fromIntegral

findMaxCommon :: String -> String -> String
findMaxCommon s1 s2 = process_i 0 ""
  where
    lenS1 = length s1
    
    process_i i maxCommon
        | i >= lenS1 = maxCommon
        | otherwise =
            let currentMaxLen = length maxCommon
                startJ = i + currentMaxLen + 1
                newMax = process_j startJ maxCommon
            in process_i (i + 1) newMax
      where
        process_j j currentMax
            | j > lenS1 = currentMax
            | otherwise =
                let sub = take (j - i) $ drop i s1
                in if sub `isInfixOf` s2
                    then process_j (j + 1) sub  -- Нашли подстроку, продолжаем искать длиннее
                    else currentMax              -- Не нашли, возвращаем текущий максимум

findMin :: [String] -> Maybe String
findMin [] = Nothing
findMin xs = Just $ minimumBy (comparing length) xs

setUnite :: [String] -> [String] -> [String]
setUnite subs1 subs2 =
  Set.toList $ Set.union (Set.fromList subs1) (Set.fromList subs2)

findCommon :: [String] -> [String] -> [String]
findCommon subs1 subs2 =
  Set.toList $ Set.intersection (Set.fromList subs1) (Set.fromList subs2)

findUniqueInFirst :: [String] -> [String] -> [String]
findUniqueInFirst subs1 subs2 =
  Set.toList $ Set.difference (Set.fromList subs1) (Set.fromList subs2)

cleanText :: String -> String
cleanText = 
     filter isAlpha

getSubstrings :: String -> Int -> Int -> [String]
getSubstrings text minLen maxLen =
  let
    cleanedText = filter isAlpha text
    n = length cleanedText
  in
    concat
      [ [ take l (drop i cleanedText) | i <- [0 .. n - l] ]
      | l <- [minLen .. maxLen],
        l <= n
      ]
main = do
  seq1 <- readFile "seq1.txt"
  seq2 <- readFile "seq2.txt"
  seq3 <- readFile "seq3.txt"
  let subs1 = getSubstrings seq1 2 6
  let subs2 = getSubstrings seq2 2 6
  let subs3 = getSubstrings seq3 2 6
  let unique1 = findUniqueInFirst subs1 subs2
  let unique2 = findUniqueInFirst subs2 subs1
  let unique33 = findUniqueInFirst subs3 subs1
  let common12 = findCommon subs1 subs2
  let unique3 = findUniqueInFirst unique33 subs2
  let subs23 = setUnite subs2 subs3
  let missingin23 = findUniqueInFirst subs1 subs23
  let minuniq1 = findMin unique1
  let minuniq2 = findMin unique2
  let mincommon12 = findMin common12
  let minmissingin23 = findMin missingin23
  let minuniq3 = findMin unique3
  let seqcl1 = cleanText seq1
  let seqcl3 = cleanText seq3
  let maxcommon = findMaxCommon seqcl1 seqcl3
  let ratio = length maxcommon `foo` length seqcl1 
  putStrLn "min uniq for 1 but missing in 2:"
  print minuniq1
  putStrLn "min uniq for 2 but missing in 1:"
  print minuniq2
  putStrLn "min common for 1 and 2:"
  print mincommon12
  putStrLn "min uniq for 1 but missing in 2 and 3:"
  print minmissingin23
  putStrLn "min uniq for 3 but missing in 1 and 2:"
  print minuniq3
  putStrLn "max common for 1 and 3"
  print maxcommon
  putStrLn "ratio of length of substring to length 1:" 
  print ratio