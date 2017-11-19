connect_to_mydb <- function(db_name) {

  require(DBI)
  require(RMySQL)
  
  tryCatch({
      cat('Attempting to connect to', db_name, '\n')
      con <- dbConnect(drv = RMySQL::MySQL(),
                       user = Sys.getenv('dbusr'),
                       password = Sys.getenv('dbpwd'),
                       host = Sys.getenv('dbhost'),
                       port = 3306L,
                       dbname = db_name)
      cat('Connection successful!\n')
  }, error = function(e) cat('Failed to establish connection\n'))
  
  con
  
}