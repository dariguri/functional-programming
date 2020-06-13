{-# LANGUAGE OverloadedStrings #-}
module Show
    ( showAll
    ) where
import qualified System.IO.Streams as Streams
import Database.MySQL.Base
import Utils

showAll connection table = do
    let str =  toByteString ("SELECT * FROM " ++ table)
    columns <- getTableColumns connection table
    (defs, is) <- query_ connection (Query str)
    values <- Streams.toList is
    prettyPrintResultSet columns values
    -- print "A"
    -- print $ map (\x -> map convert x) values