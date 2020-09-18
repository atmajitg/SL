library(pacman)
pacman::p_load(odbc, RMySQL, here)
##---------------------------------------------------------
#test if aws db read/write works
source(here('DB_fun', 'AWS_readwrite.R'))
#test database read function
customSQL = 'SELECT * FROM sendtest1'
dt1 = FUN_DBreadSQL(customSQL)

dt1$newcol = c(0,3,6)

#test database write function
FUN_DBwriteSQL(mydata = dt1, tablename = 'sendtest1', OverwriteAppend = 'OVERWRITE')

#read table again to confirm updated
dt1_updated = FUN_DBreadSQL(customSQL)
