tab_individual = tabItem(
    tabName = "individual",
    uiOutput("runner_filter"),
    br(),
    fluidRow(
      valueBoxOutput("total_runs_ind", width = 3),
      valueBoxOutput("total_distance_ind", width = 3),
      valueBoxOutput("total_time_ind", width = 3),
      valueBoxOutput("avg_pace_ind", width = 3)
    ),

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
