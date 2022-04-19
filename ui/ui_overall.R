tab_overall = tabItem(
    tabName = "overall",
    h2("Top Runners"),
    br(),
    fluidRow(
      valueBoxOutput("first_runner"),
      valueBoxOutput("second_runner"),
      valueBoxOutput("third_runner")
    ),
  
    h2("Runs"),
    br(),
    fluidRow(
      box(
        title = "Pace vs Distance",
        status = "primary",
        solidHeader = TRUE,
        plotlyOutput("pace_vs_distance")
      ),
      box(
        title = "Smart Avg. Pace",
        status = "primary",
        solidHeader = TRUE,
        plotlyOutput("avg_pace")
      )
    ),
    br(),
    fluidRow(
      box(
        title = "Totals",
        status = "primary",
        solidHeader = TRUE,
        formattableOutput("overall_table")
      )
    )
)