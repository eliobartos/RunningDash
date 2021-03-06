library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyTime)

library(DBI)
library(RPostgreSQL)
library(dbplyr)

library(plotly)
library(lubridate)
library(dplyr)
library(magrittr)
library(formattable)

# packages = c(
#     # Shiny Related Packages
#     "shiny",
#     "shinydashboard",
#     "shinyWidgets",
#     "shinyTime",
# 
#     # DB Related Packages
#     "DBI",
#     "RPostgreSQL",
# 
#     # Other Packages
#     "plotly",
#     "lubridate",
#     "dplyr",
#     "magrittr",
#     "formattable"
#     )
# 
# install_if_missing = function(p) {
#   if (p %in% rownames(installed.packages()) == FALSE) {
#     install.packages(p)
#   }
# }
# 
# #invisible(sapply(packages, install_if_missing))
# invisible(lapply(packages, library, character.only = TRUE))
