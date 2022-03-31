# Shiny Related Packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyTime)

# Other Packages
library(plotly)
library(lubridate)
library(dplyr)
library(magrittr)

# Connect to DB
source(".sql_connector.R")

# Source UI
source('ui/ui_base.R')

# Source server side functions
source("server/server.R")
source("server/func_data_processing.R")
source("server/func_overall.R")
source("server/func_individual.R")
source("server/func_input.R")
source("server/helper_functions.R")

onStop(function() {
  dbDisconnect(db)
})

shinyApp(ui = ui, server = server)
