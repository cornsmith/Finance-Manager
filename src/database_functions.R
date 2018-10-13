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

sql_update <- function(update_table, set_fields, source_fields, source_values, key){
  paste(
    "UPDATE", update_table,
    "SET", paste(paste0(set_fields, " = SRC.", set_fields), collapse = ","),
    "FROM (VALUES", source_values, ") AS SRC",
    "(", paste(source_fields, collapse = ","), ")", 
    "WHERE", paste(paste0(update_table, ".", key, " = SRC.", key), collapse = " AND "),
    ";"
  )
}