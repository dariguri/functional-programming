{-# LANGUAGE OverloadedStrings #-}
import Test.HUnit
import Select
import Insert
import Delete
import Update
import Database.MySQL.Base
testSelect:: Test
testSelect = TestCase (do 
    connection <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_software"}
    (cols, res) <- select_base connection "versions" "version" "varchar" "1.1"
    assertBool "Result is not empty" ((length res) > 0)
    assertEqual "Release info is correct" (MySQLText "release version") ((res !! 0) !! 3)
    close connection)

testInsert = TestCase (do 
    connection <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_software"}
    deleteFrom connection "users" "name" "varchar" "user1"
    insertInto connection "users" ["user1","user2","25"]
    (cols, res) <- select_base connection "users" "name" "varchar" "user1"
    assertBool "Result is not empty" ((length res) > 0)
    assertEqual "Release info is correct" (MySQLText "user1") ((res !! 0) !! 1)
    deleteFrom connection "users" "name" "varchar" "user1"
    close connection)

testDelete = TestCase (do
    connection <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_software"}
    insertInto connection "users" ["user1","user2","25"]
    deleteFrom connection "users" "name" "varchar" "user1"
    (cols, res) <- select_base connection "users" "name" "varchar" "user1"
    assertBool "Result is empty" ((length res) == 0)
    close connection)

testUpdate = TestCase (do
    connection <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_software"}
    deleteFrom connection "users" "name" "varchar" "user1"
    insertInto connection "users" ["user1","user2","25"]
    (cols, res) <- select_base connection "users" "name" "varchar" "user1"
    let id = (res !! 0) !! 0
    let str_id = show (case id of  MySQLInt32 x -> x)
    update connection "users" id "name" "varchar" "updated_user"
    (cols, res) <- select_base connection "users" "id" "int" str_id
    assertBool "Result is not empty" ((length res) > 0)
    assertEqual "Release info is correct" (MySQLText "updated_user") ((res !! 0) !! 1)
    close connection)
main :: IO Counts
main = do
    runTestTT testSelect
    runTestTT testInsert
    runTestTT testDelete
    runTestTT testUpdate