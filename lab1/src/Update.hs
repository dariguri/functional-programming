{-# LANGUAGE OverloadedStrings #-}
module Update
    ( update
    ) where

import Utils
import qualified System.IO.Streams as Streams
import Database.MySQL.Base
import Data.List

update::MySQLConn->[Char]->MySQLValue->[Char]->[Char]->[Char]->IO ()
update connection table id field s_type value  = do
    let str = toByteString $ "UPDATE " ++ table ++ " SET " ++ field ++ " = ? where id = ?"
    print str
    s <- prepareStmt connection (Query str)
    executeStmt connection s [packIntoMySQLValue s_type value, id]
    execute_ connection "commit"
    -- commit connection
    putStrLn "Update is done"