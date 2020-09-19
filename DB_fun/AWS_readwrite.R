#Connection function to db
FUN_DBconn = function(){
  host='database-2.cl2cp13tntsx.us-east-2.rds.amazonaws.com'
  port=3306
  dbname='TEST1'
  user='admin'
  password='socratictest'
  con=dbConnect(RMySQL::MySQL(),dbname=dbname,host=host,port=port,user=user,password=password)
  
  return(con)
}

#Pool connection function to db
FUN_DBpool = function(){
  host='database-2.cl2cp13tntsx.us-east-2.rds.amazonaws.com'
  port=3306
  dbname='TEST1'
  user='admin'
  password='socratictest'
  dbpool=dbPool(RMySQL::MySQL(),
                dbname=dbname,
                host=host,
                port=port,
                user=user,
                password=password)
  
  return(dbpool)
}

#Function to write dataframe to aws sql database
#mydata = dataframe
#tablename = new or existing table in database
#OverwriteAppend = flag "OVERWRITE" or "APPEND", use overwrite to create new table
FUN_DBwriteSQL = function(mydata, tablename, OverwriteAppend){
  
  con = FUN_DBconn()
  
  if(OverwriteAppend == 'OVERWRITE'){
    dbWriteTable(con, tablename, mydata, overwrite = T, append = F, row.names=F)	
  } else if(OverwriteAppend == 'APPEND'){
    dbWriteTable(con, tablename, mydata, overwrite = F, append = T, row.names=F)	  
  }
  
  dbDisconnect(con)
  
}

#Function to read aws sql database table to dataframe object via custom query
FUN_DBreadSQL = function(customSQL){
  
  con = FUN_DBconn()
  
  mydata <- dbGetQuery(con, customSQL)	
  dbDisconnect(con)
  
  return(mydata)
  
}

