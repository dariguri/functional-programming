import Data.List

func :: [Int] -> Bool
func n = (sum n <= 6)

checkList :: (Ord a, Num a) => [a] -> Bool
checkList [] = True
checkList [x] = True
checkList (x:y:xs) = (x + y <= 4) && checkList (y:xs)

main :: IO()
main = do 
    let n = 4
    let xs = [1, 2, 3]
    let list = mapM (const xs) [1..n]
    let result = filter (checkList) list
    print (result)