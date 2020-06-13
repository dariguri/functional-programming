{-# LANGUAGE OverloadedStrings #-}
module Delete
    ( deleteFrom
    ) where

import Utils
import qualified System.IO.Streams as Streams
import Database.MySQL.Base
import Data.List

deleteFrom::MySQLConn->[Char]->[Char]->[Char]->[Char]->IO ()
deleteFrom connection table field s_type value = do
    let str = toByteString $ "DELETE FROM " ++ table ++ " WHERE  " ++ field ++ " = ?"
    print str
    s <- prepareStmt connection (Query str)
    executeStmt connection s [packIntoMySQLValue s_type value]
    execute_ connection "commit"
    -- commit connection
    putStrLn "Delete is done"