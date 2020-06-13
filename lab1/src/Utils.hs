{-# LANGUAGE OverloadedStrings #-}
module Utils
    ( convert, toByteString, toText,packIntoMySQLValue,getTableColumns,prettyPrintResultSet,getAllTables,getTableTypes
    ) where
import qualified System.IO.Streams as Streams
import qualified Data.Text as T
import Database.MySQL.Base
import qualified Data.ByteString.Lazy.Char8 as C
import Data.Time
import Data.Int
import Data.List

convert::MySQLValue -> [Char]
convert (MySQLInt32 x) = show x
convert (MySQLText x) = T.unpack x
convert (MySQLDateTime x) = show x
convert x = show x

toByteString x = C.pack x

toText x = T.pack x
packIntoMySQLValue::[Char]->[Char]->MySQLValue
packIntoMySQLValue s_type value 
    | "int" `isInfixOf` s_type = MySQLInt32 (read value::Int32)
    | "varchar" `isInfixOf` s_type = MySQLText (toText value) 
    | "datetime" `isInfixOf` s_type = MySQLDateTime (parseTimeOrError True defaultTimeLocale "%Y-%m-%d %H:%M" value :: LocalTime)
    | otherwise = MySQLNull

prettyPrintResultSet::[[Char]]->[[MySQLValue]]->IO()
prettyPrintResultSet columns values = do 
    mapM_ (\x -> putStr $ x ++ ",\t") columns
    putStrLn ""
    mapM_ (\x-> do 
        mapM_ (\y -> putStr $ convert y ++ ";\t") x 
        putStrLn "") values

getTableColumns :: MySQLConn -> [Char] -> IO [[Char]]
getTableColumns connection table = do
    let str = toByteString $ "SHOW COLUMNS FROM " ++ table
    (defs, is) <- query_ connection (Query str)
    values <- Streams.toList is
    return $ map (convert . head) values

getTableTypes connection table = do
    let str = toByteString $ "SHOW COLUMNS FROM " ++ table
    (defs, is) <- query_ connection (Query str)
    values <- Streams.toList is
    return $ map (\x -> convert $ x !! 1 ) values

getAllTables connection = do
    (defs, is) <- query_ connection "SELECT table_name FROM information_schema.tables WHERE table_schema ='faculty_software'"
    values <- Streams.toList is
    return $ map (convert . head) values