import System.IO(readFile, writeFile)
import System.Environment(getArgs)
import Data.List (group)

main :: IO ()
main = do
    fileName <- head <$> getArgs
    writeFile (fileName ++ "-out.hs") 
        =<<  stringOps
        . unlines 
        . lineOps 
        . lines 
        <$> readFile fileName
        where
            lineOps = map trimLastWhitespaces . filter (not . isWhitespace)
            stringOps = trimNewlines 

isWhitespace :: String -> Bool
isWhitespace [] = False
isWhitespace line = all (`elem` [' ', '\t']) line

trimNewlines :: String -> String
trimNewlines = 
    concatMap enforceTwoSequentialNewlineMax . group  

enforceTwoSequentialNewlineMax :: String -> String
enforceTwoSequentialNewlineMax (x:xs)
    | x == '\n' && length xs > 2 = "\n\n" 
    | otherwise = x:xs

trimWhitespaceOnlyLines :: String -> String
trimWhitespaceOnlyLines line 
    | isWhitespace line = ""
    | otherwise = line

trimLastWhitespaces :: String -> String
trimLastWhitespaces [] = []
trimLastWhitespaces line
    | last line == ' ' || last line == '\t' = trimLastWhitespaces $ init line
    | otherwise = line