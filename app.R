# Packages ----------------------------------------------------------------
library(shiny)
library(shinydashboard)
library(rhandsontable)


# Pre-processing ----------------------------------------------------------
source("./src/main.R", local = TRUE)


# UI ----------------------------------------------------------------------
# Sidebar
sidebar <- dashboardSidebar(sidebarMenu(
  
  menuItem(
    text = "Total Position",
    tabName = "total_position",
    icon = icon("star")
  ),
  
  menuItem(
    text = "Account Position",
    tabName = "account_position",
    icon = icon("file")
  ),
  
  menuItem(
    text = "Budget",
    tabName = "budget",
    icon = icon("calculator")
  ),
  
  menuItem(
    text = "Transactions",
    tabName = "transaction",
    icon = icon("book"),
    selected = TRUE
  )
  
))

# Body
body <- dashboardBody(tabItems(
  
  tabItem(
    tabName = "total_position",
    h2("Total Position"),
    plotOutput("Total_Position_Plot")
  ),
  
  tabItem(
    tabName = "account_position",
    h2("Account Position"),
    selectInput(
      inputId = "account_number",
      label = "Account Number",
      choices = list(
        "Transaction" = df_account$account_number[df_account$account_type == "Transaction"],
        "Credit Card" = df_account$account_number[df_account$account_type == "Credit Card"],
        "Home Loan" = df_account$account_number[df_account$account_type == "Home Loan"]
      )
    ),
    plotOutput("Account_Position_Plot")
  ),
  
  tabItem(
    tabName = "budget",
    h2("Budget"),
    tableOutput("Budget_Table")
  ),
  
  tabItem(
    tabName = "transaction",
    h2("Transactions"),
    rHandsontableOutput("hot"),
    actionButton(inputId = "save_transaction", label = "Save", icon = icon("save"))
  )
  
))

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Finance Manager"),
  sidebar,
  body
)

# Server ------------------------------------------------------------------
server <- function(input, output) {
  
  output$Total_Position_Plot <- renderPlot({
    df_total_position %>%
      ggplot(aes(date, balance)) +
      geom_line() +
      theme_minimal()
  })
  
  output$Account_Position_Plot <- renderPlot({
    df_account_position %>%
      filter(account_number == input$account_number) %>%
      ggplot(aes(date, balance)) +
      geom_line() +
      theme_minimal()
    
  })
  
  output$Budget_Table <- renderTable(
    df_transactions %>% 
      filter(date >= lubridate::today() - 365) %>% 
      group_by(display_order, transaction_category_group, transaction_category, income_expense_category) %>% 
      summarise(amount = sum(amount))
  )
  
  values <- reactiveValues()
  data <- reactive({
    if (!is.null(input$hot)) {
      DF <- hot_to_r(input$hot)
    } else {
      if (is.null(values[["DF"]])){
        DF <- df_transactions %>% 
          filter(is.na(transaction_category)) %>% 
          select(c("id", "description", "amount", "date", "account_type", "amount", "transaction_category")) %>% 
          sample_n(20)
      } else {
        DF <- values[["DF"]]
      }
    }
    values[["DF"]] = DF
    return(DF)
  })
  
  output$hot <- renderRHandsontable({
    rhandsontable(data(), rowHeaders = NULL, search = TRUE, stretchH = "all") %>% 
      hot_cols(readOnly = TRUE) %>% 
      hot_col("transaction_category", readOnly = FALSE) %>% 
      hot_col(col = "transaction_category", type = "autocomplete", source = df_category$transaction_category)
  })
  
  observeEvent(
    input$save_transaction, 
    {
      df <- hot_to_r(input$hot) %>% 
        filter(!is.na(transaction_category)) %>% 
        inner_join(df_category, by = "transaction_category") %>% 
        select(c("id.x", "id.y"))
        
      values <- paste(
        apply(df, 1, function(x){
          paste0("(", paste(x, collapse = ","), ")")
        }), 
        collapse = ","
      )
      
      qry <- sql_update(
        update_table = "transaction", 
        set_fields = "transaction_category_id", 
        source_fields = c("id", "transaction_category_id"), 
        source_values = values, 
        key = "id"
      )
      con <- open_connection()
      dbSendQuery(conn = con, statement = qry)
      dbDisconnect(con)
    }
  )
}

# Run app -----------------------------------------------------------------
shinyApp(ui = ui, server = server)
