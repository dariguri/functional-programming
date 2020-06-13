{-# LANGUAGE OverloadedStrings #-}
module ConsoleInterface (
consoleInterfaceStart
) where
import Database.MySQL.Base
import Utils
import Show
import Insert
import Update
import Delete
import Select
import Data.Int
printList::[[Char]]->IO()
printList x = mapM_ (\(a,b) -> do 
    putStr (show a) 
    putStrLn $ ". "++b) (zip [1..] x)

getInt::Int->Int->IO Int
getInt min max = do
    putStrLn $"Enter the number from " ++ show min ++ " to " ++ show max
    str <- getLine
    let a = read str::Int
    if a >= min && a <= max then return a 
    else 
        do
            putStrLn "Enter the number again"
            getInt min max

consoleInterfaceTableAction::MySQLConn->[Char]->IO ()
consoleInterfaceTableAction conn table = do
    putStrLn $ table
    putStrLn "1. Show the table\n2. Insert into the table\n3. Update rows of the table\n4. Delete rows from the table\n5. Show rows\n6. Go back"
    i <- getInt 1 6
    -- print i
    if (i == 1)
        then do
            showAll conn table
            consoleInterfaceTableAction conn table
    else if i == 2 
        then do
            val <- getTableColumns conn table
            let columns = tail val
            values <- mapM (\name->do 
                putStrLn ("Enter the value for '"++name++"' field") 
                getLine) columns
            -- print values
            insertInto conn table values
            consoleInterfaceTableAction conn table
    else if i == 3 
        then do
            putStrLn "Enter the id of the value:"
            id_s <- getLine
            let id = MySQLInt32 (read id_s::Int32)
            putStrLn "Choose column to update:"
            cols <- getTableColumns conn table
            printList cols
            index <- getInt 1 (length cols)
            let field = cols !! (index - 1)
            putStrLn "Enter value for the field:"
            value <- getLine
            types <- getTableTypes conn table
            let type_s = types !! (index - 1)
            update conn table id field type_s value 
            consoleInterfaceTableAction conn table
    else if i == 4 || i == 5
        then do
            putStrLn "Choose field:"
            cols <- getTableColumns conn table
            printList cols
            index <- getInt 1 (length cols)
            let field = cols !! (index - 1)
            putStrLn "Enter value for the field:"
            value <- getLine
            types <- getTableTypes conn table
            let type_s = types !! (index - 1)
            if i == 4 then 
                deleteFrom conn table field type_s value
            else
                select conn table field type_s value
            consoleInterfaceTableAction conn table

    else consoleInterfaceStart conn
    --     
    --     return consoleInterfaceTableAction conn table
        -- else if i == 2 
        --     then do
        --         val <- getTableColumns conn table
        --         let columns = tail val
        --         values <- mapM (\name->do putStrLn ("Enter the value for '"++name++"' field") return getLine) columns
        --         print "a"
consoleInterfaceStart conn = do
    tables <- getAllTables conn
    putStrLn "Tables: "
    printList tables
    a <- getInt 1 ((length tables)+1)
    if a == (length tables) + 1 then return ()
    else consoleInterfaceTableAction conn (tables !! (a - 1))
    -- print a
