import Data.Typeable

type Function = Int -> Bool

checkCond :: [Int] -> Function -> Bool
checkCond a b = True

main :: IO()
main = do print  (typeOf checkCond)