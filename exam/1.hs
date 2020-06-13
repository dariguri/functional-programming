lists :: Int -> [[Int]]
lists 1 = [[1], [2], [3]]
lists n = (map (1:) (lists (n-1))) ++ (map (2:) (lists (n-1))) ++ (map (3:) (lists (n-1)))

deleteRedundant :: [[Int]] -> [[Int]]
deleteRedundant []= []
deleteRedundant (x:xs) | (filterFour x) = x : (deleteRedundant xs)
                       | otherwise = deleteRedundant xs

filterFour:: [Int] -> Bool
filterFour [] = True
filterFour (x:[]) = True
filterFour (x:y:xs) | x+y > 4 = False 
                     | otherwise = filterFour (y:xs)

main = do 
    let res = deleteRedundant $ lists 3
    putStrLn ( show res)