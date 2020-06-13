{-# LANGUAGE OverloadedStrings #-}
module Select
    ( select,select_base
    ) where

import Utils
import qualified System.IO.Streams as Streams
import Database.MySQL.Base
import Data.List

select_base::MySQLConn->[Char]->[Char]->[Char]->[Char]->IO ([[Char]],[[MySQLValue]])
select_base connection table field s_type value = do
    let str = toByteString $ "SELECT * FROM " ++ table ++ " WHERE  " ++ field ++ " = ?"
    print str
    s <- prepareStmt connection (Query str)
    (defs, is) <- queryStmt connection s [packIntoMySQLValue s_type value]
    values <- Streams.toList is
    columns <- getTableColumns connection table
    return (columns, values)
select::MySQLConn->[Char]->[Char]->[Char]->[Char]->IO ()
select connection table field s_type value = do
    (columns, values)<-select_base connection table field s_type value
    prettyPrintResultSet columns values
    