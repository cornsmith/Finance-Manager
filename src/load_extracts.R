# Functions ---------------------------------------------------------------
detect_account_type <- function(account_number){
  account_type <- case_when(
    str_detect(string = account_number, pattern = "^[4-5]") ~ "Credit Card",
    str_length(string = account_number) == 15 ~ "Home Loan",
    str_detect(string = account_number, pattern = "^(06)") ~ "Transaction"
  )
  return(account_type)
}

load_file <- function(filename){
  
  # read file
  df <- read_csv(
    file = filename,
    col_names = c("date", "amount", "description"),
    col_types = list(
      col_date(format = "%d/%m/%Y"),
      col_double(),
      col_character(),
      col_skip()
    )
  )
  
  # transform raw data
  df <- df %>% 
    mutate(
      description = str_replace(string = description, pattern = "^(AMEX )", replacement = "")
    )
  
  # extract account name from directory
  filename_components <- str_split(string = filename, pattern = "/")[[1]]
  account_number <- filename_components[length(filename_components) - 1]
  account_number <- str_replace_all(string = account_number, pattern = " ", replacement = "")
  
  # get/set account table
  account_id <- dbGetQuery(con, paste("SELECT id FROM account WHERE account_number =", sql_quote(account_number)))
  if(nrow(account_id) == 0){
    account_type <- detect_account_type(account_number)
    account_type_id <- dbGetQuery(con, paste("SELECT id FROM account_type WHERE account_type =", sql_quote(account_type)))[[1]]
    account_df <- data.frame(
      account_number = account_number,
      account_type_id = account_type_id
    )
    dbWriteTable(con, "account", account_df, append = TRUE, row.names = FALSE)
    account_id <- dbGetQuery(con, paste("SELECT id FROM account WHERE account_number =", sql_quote(account_number)))
  }
  account_id <- account_id[[1]]
  
  # get/set description table
  description_df <- dbGetQuery(con, "SELECT description FROM description")
  description_df <- data.frame(description = setdiff(df$description, description_df$description))
  dbWriteTable(con, "description", description_df, append = TRUE, row.names = FALSE)
  description_df <- dbGetQuery(con, "SELECT id as description_id, description FROM description")
  
  # prepare transaction data frame
  df <- df %>% 
    inner_join(description_df, by = "description") %>% 
    mutate(account_id = account_id) %>% 
    select(-one_of("description"))
  
  # get/set transaction table
  transaction_df <- dbGetQuery(con, "SELECT * FROM transaction")
  transaction_fields <- dbListFields(con, "transaction")
  transaction_fields <- setdiff(transaction_fields, c("id", "transaction_category_id"))
  if(nrow(transaction_df) > 0){
    transaction_df <- setdiff(df[ , transaction_fields], transaction_df[ , transaction_fields])
  } else {
    transaction_df <- df[ , transaction_fields]
  }
  dbWriteTable(con, "transaction", transaction_df, append = TRUE, row.names = FALSE)
  
  return(TRUE)
}

# Procedure ---------------------------------------------------------------
# import files into master files
import_files <- list.files(path = dir_import_transactions, full.names = TRUE, recursive = TRUE)
sapply(import_files, load_file)

# Clean Up ----------------------------------------------------------------
rm(import_files, load_file, detect_account_type)
