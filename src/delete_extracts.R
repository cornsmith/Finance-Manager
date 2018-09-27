# Delete extracts ---------------------------------------------------------
import_files <- list.files(path = dir_import_transactions, full.names = TRUE, recursive = TRUE)
sapply(import_files, file.remove)


# Clean Up ----------------------------------------------------------------
rm(import_files)
