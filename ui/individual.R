tab_individual = tabItem(
    tabName = "individual",
    uiOutput("runner_filter"),
    
    h2("Runs over time"),
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
         plotlyOutput("pace_vs_run")  
      )
    )
                         
)