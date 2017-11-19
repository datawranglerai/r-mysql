rmysql_update <- function(con, x, table, verbose = TRUE) {
  
  # AIM: Perform table update with iterative row insertion
  # UPDATE: https://dev.mysql.com/doc/refman/5.7/en/insert-on-duplicate.html
  
  require(DBI)
  require(RMySQL)
  
  # Find column names of table
  rs <- dbSendQuery(con, paste0('SHOW COLUMNS FROM ', table, ';'))
  col_names <- dbFetch(rs)
  dbClearResult(rs)
  
  # Find which columns are primary keys and make sure they're not included in the update statement
  pri <- which(col_names$Key == "PRI")
  
  # For each row of table, update db
  for(i in 1:nrow(x)) {
    
    values <- sapply(x[i, ], as.character)
    
    # Build the INSERT/UPDATE query
    myquery <- paste0("INSERT INTO ",
                      table,
                      "(", paste(col_names$Field, collapse = ", "), ") ", # column names
                      "VALUES",
                      "('", paste(values, collapse = "', '"), "') ", # new records
                      "ON DUPLICATE KEY UPDATE ",
                      paste(col_names$Field[-pri], values[-pri], sep = " = '", collapse = "', "), # everything minus primary keys
                      "';")
    
    if(verbose) cat("Performing query:\n", myquery, "\n")
    
    # Send query to database
    dbSendQuery(con, myquery)
    
  }
  
}