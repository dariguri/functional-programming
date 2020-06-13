{-# LANGUAGE OverloadedStrings #-}
module Main where
import Database.MySQL.Base
import Show
import Insert
import Update
import Delete
import Select
import ConsoleInterface
-- match12 :: MySQLValue -> a
-- match12 (MySQLInt32 x) = x 
-- -- match12 (MySQLText x) = x
-- match12 (MySQLDateTime x) = x
-- match12 _ = 0
-- b=[MySQLInt32]
a =["a","b"]
main :: IO ()
main =  do
    conn <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_software"}
    consoleInterfaceStart conn
    -- -- (defs, is) <- query_ conn "SELECT table_name FROM information_schema.tables WHERE table_schema ='faculty_software'"
    -- showAll conn "versions"
    -- -- (defs, is) <- query_ conn "SELECT * FROM versions"
    
    -- -- -- a <- Streams.read is
    -- -- -- case a of 
    -- -- --     Just x -> print $ case (x !! 1) of MySQLText x -> x
    -- -- --     Nothing -> print "Nothing"
    -- -- -- -- print (a !! 0)
    -- -- values <- Streams.toList is
    -- -- -- print $ map (\x -> case x of [MySQLText y] -> y) values
    -- -- print values

    -- -- insertInto conn "versions" ["1","0.19a", "Add project files", "2019-05-05 11:15"]
    -- -- update conn "versions" (MySQLInt32 2) "release_info" "varchar" "release version"
    -- -- deleteFrom conn "versions" "id" "int" "10"
    -- select conn "versions" "version" "varchar" "0.19a"
    -- print a
    close conn
