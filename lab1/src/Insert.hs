{-# LANGUAGE OverloadedStrings #-}
module Insert
    ( insertInto
    ) where
import Utils
import qualified System.IO.Streams as Streams
import Database.MySQL.Base
import Data.List

matchType::[[Char]]->[[Char]]->[MySQLValue]
matchType [] _ = []
matchType _ [] = []
matchType (t:s_types) (v:values) = packIntoMySQLValue t v : matchType s_types values

getFieldAndTypes::MySQLConn->[Char]->[[Char]]->IO ([[Char]],[MySQLValue])
getFieldAndTypes connection table values = do
    let str = toByteString $ "SHOW COLUMNS FROM " ++ table
    (defs, is) <- query_ connection (Query str)
    data1 <- Streams.toList is
    let fields = map (convert . head) (tail data1)
    let s_types = map (\x-> convert $ x !! 1) (tail data1)
    let types = matchType s_types values
    return (fields, types)

insertInto connection table values = do
    vals <- getFieldAndTypes connection table values
    let fields = fst vals
    let types = snd vals
    let substitute = intercalate ", " (replicate (length fields) "?")
    -- let substitute = foldl (\a b ->a ++ ",?") "" fields
    let fields_str = intercalate ", " fields
    let str = toByteString $ "insert into " ++ table ++ " (" ++ fields_str ++ ") VALUES (" ++ substitute ++ ")"
    print str
    print types
    s <- prepareStmt connection (Query str)
    executeStmt  connection s types
    execute_ connection "commit"
    putStrLn "Insertion is done"