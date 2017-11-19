datawrangler_ai_connect <- function(db_name) {

  require(DBI)
  require(RMySQL)
  
  tryCatch({
      print(paste('Attempting to connect to', db_name))
      con <- dbConnect(drv = RMySQL::MySQL(),
                       user = Sys.getenv('dbusr'),
                       password = Sys.getenv('dbpwd'),
                       host = Sys.getenv('dbhost'),
                       port = 3306L,
                       dbname = db_name)
      print('Connection successful!')
  }, error = function(e) print('Failed to establish connection'))
  
  con
  
}