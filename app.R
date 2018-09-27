# Packages ----------------------------------------------------------------
library(shiny)
library(shinydashboard)


# Pre-processing ----------------------------------------------------------
source("./src/main.R", local = TRUE)


# UI ----------------------------------------------------------------------
# Sidebar
sidebar <- dashboardSidebar(sidebarMenu(
  
  menuItem(
    text = "Total Position",
    tabName = "total_position",
    icon = icon("star"), 
    selected = TRUE
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
      group_by(display_order, transaction_category_group, transaction_category) %>% 
      summarise(amount = sum(amount))
  )
  
  
}

# Run app -----------------------------------------------------------------
shinyApp(ui = ui, server = server)
