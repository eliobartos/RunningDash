library(shiny)
library(shinydashboard)

library(plotly)
library(lubridate)
library(dplyr)
library(magrittr)

source("sql_connector.R")
source("helper_functions.R")



ui = dashboardPage(skin = "blue",
  dashboardHeader(title = "RunDash"),
  dashboardSidebar(
    sidebarMenu(
      selectInput(
        'date_filter', 'Period:', 
        choices = c('Last 30 Days', 'All Time'), 
        selected = 'Last 30 Days'
      ),
      menuItem("Overall", tabName = "overall", icon = icon("globe")),
      menuItem("Individual Progress", tabName = "individual", icon = icon("globe")),
      menuItem("Add new run", tabName = "input", icon = icon("pencil-square-o"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "overall",
        h2("Top Runners"),
        br(),
        br(),
        fluidRow(
          valueBoxOutput("first_runner"),
          valueBoxOutput("second_runner"),
          valueBoxOutput("third_runner")
        ),
        h2("Runs"),
        br(),
        br(),
        fluidRow(
          box(
              title = "Pace vs Distance",
              status = "primary",
              solidHeader = TRUE,
              plotlyOutput("pace_vs_distance")
          ),
          box(
              title = "Avg Pace",
              status = "primary",
              solidHeader = TRUE,
              plotlyOutput("avg_pace")
          ),
          
          
        )
      ),
      tabItem(tabName = "individual",
        h2("Runs over time"),
        br(),
        br(),
        fluidRow(
          box(
            title = "Runs over time",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("distance_vs_date")
          )
        ),
        fluidRow(
          box(
            title = "Distance vs Run",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("distance_vs_run")  
          ),
          box(
            title = "Pace vs Run",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("distance_vs_run")  
          )
        )
        
      ),
      tabItem(tabName = "input")
    )
  )
)

server = function(input, output) {
  
  
  data_all = dbGetQuery(db, "select * from runs") %>% 
    as.data.frame()
  
  data_all = data_all %>% 
    mutate(
      time_s = as.numeric(hms(time)),
      pace = time_s/distance/60,
      pace_pretty = minutes_to_ms(pace)
    )
  
  data = reactive({
    
    if(input$date_filter == 'Last 30 Days') {
      return(data_all %>% filter(date >= today() - 31))
    } else {
      return(data_all)
    }

  })

# Top Runners -------------------------------------------------------------
  output$first_runner = renderValueBox({
    valueBox("Anci", "1st - 30 km", icon = icon("trophy"), color = "orange")
  })
  
  output$second_runner = renderValueBox({
    valueBox("Elio", "2nd - 25 km", icon = icon("play"), color = "green")
  })
  
  output$third_runner = renderValueBox({
    valueBox("Hop", "3rd - 13 km", icon = icon("listfaet"), color = "navy")
  })
  

# Overall Graphs ----------------------------------------------------------
  output$pace_vs_distance = renderPlotly({
    plot_ly(data = data(), x = ~distance, y = ~pace, color =~runner,
            marker = list(size = 10)) %>% 
      layout(
        xaxis = list(rangemode = "tozero", zeroline = FALSE), 
        yaxis = list(rangemode = "tozero", zeroline = FALSE))
  })
  
  output$avg_pace = renderPlotly({
    tmp = data() %>% 
      mutate(
        distance_group = cut(distance, breaks = c(0, seq(0.5, 100.5, by = 1), Inf), labels = c(0, seq(1, 100, by = 1), 101)) %>% as.character() %>%  as.numeric()
      ) %>% 
      group_by(runner, distance_group) %>% 
      summarise(
        time = sum(time_s),
        distance_ = sum(distance),
        avg_pace = sum(time_s)/sum(distance)/60,
        avg_pace_pretty = minutes_to_ms(avg_pace)
      )
    
    plot_ly(data = tmp, x = ~distance_group, y =~ avg_pace, color =~runner, type = 'scatter',
            marker = list(size = 10)) %>% 
      layout(
        xaxis = list(rangemode = "tozero", zeroline = FALSE), 
        yaxis = list(rangemode = "tozero", zeroline = FALSE))
  })
}

shinyApp(ui = ui, server = server)
