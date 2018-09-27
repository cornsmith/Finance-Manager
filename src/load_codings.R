# Functions ---------------------------------------------------------------
load_codings <- function(){
  # read from csv
  df_desc_cat <- read_csv(file = "./data/import/categories/description_category.csv")
  df_desc_cat <- df_desc_cat[!duplicated(df_desc_cat$description), ]
  
  # get ids from db
  description_df <- dbGetQuery(con, "SELECT id as description_id, description FROM description")
  category_df <- dbGetQuery(con, "SELECT id as transaction_category_id, transaction_category FROM transaction_category")
  
  # join to get ids
  df_desc_cat <- df_desc_cat %>% 
    inner_join(description_df, by = "description") %>% 
    inner_join(category_df, by = c("category" = "transaction_category"))
  
  # get/set description-transaction-category (dtc) table
  # TODO: The UPSERT doesn't work properly
  dtc_df <- dbGetQuery(con, "SELECT * FROM description_transaction_category")
  dtc_fields <- dbListFields(con, "description_transaction_category")
  if(nrow(dtc_df) > 0){
    dtc_df <- setdiff(df_desc_cat[ , dtc_fields], dtc_df[ , dtc_fields])
  } else {
    dtc_df <- df_desc_cat[ , dtc_fields]
  }
  dbWriteTable(con, "description_transaction_category", dtc_df, append = TRUE, row.names = FALSE)
  
  return(TRUE)
}

# Procedure ---------------------------------------------------------------
load_codings()

# Clean Up ----------------------------------------------------------------
rm(load_codings)
