# Packages ----------------------------------------------------------------
library(tidyverse)

dir_import_transactions <- "./data/import/transactions"
source("./src/database_functions.R")


# Procedure ---------------------------------------------------------------
# open connection
con <- open_connection()

source("./src/load_extracts.R")
#source("./src/delete_extracts.R")
source("./src/load_codings.R")

df_transactions <- dbGetQuery(con, "SELECT * FROM transaction_detail_view")
df_total_position <- dbGetQuery(con, "SELECT * FROM total_position_view")
df_account_position <- dbGetQuery(con, "SELECT * FROM account_position_view")
df_account <- dbGetQuery(con, "SELECT * FROM account_view")
df_category <- dbGetQuery(con, "SELECT * FROM transaction_category")

# close connection
dbDisconnect(con)


# Clean Up ----------------------------------------------------------------
rm(dir_import_transactions) #sql_insert, sql_quote, sql_values, con, open_connection, 
