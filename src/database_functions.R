require(RPostgreSQL)

# Database functions ------------------------------------------------------
open_connection <- function(){
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host = "localhost", dbname = "finance_manager", user = "postgres", password = Sys.getenv("PG_PWD"), port = 5432)
  return(con)
}


# SQL helper functions ----------------------------------------------------
sql_insert <- function(table, fields, values){
  paste(
    "INSERT INTO", table, 
    "(", paste(fields, collapse = ","), ")", 
    "VALUES", 
    values
  )
}

sql_values <- function(...){
  paste0("(", paste(..., sep = ","), ")")
}

sql_quote <- function(char){
  shQuote(char, "sh")
}