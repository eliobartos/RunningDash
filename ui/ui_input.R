tab_input = tabItem(
    tabName = "input",
    
    h2("Let me know about your run:"),
    br(),
    box(
      title = "Enter a new run:",
      status = "primary",
      solidHeader = TRUE,
      width = 4,
      textInput('runner_name', label = 'Name:', placeholder = 'Runner X'),
      airDatepickerInput("run_date", label = "Date:", value = today(), maxDate = today(), autoClose = TRUE),
      numericInput('run_distance', label = 'Distance (km):', value = 0.0, min = 0, max = 50),
      timeInput('run_time', label = "Run Time (hh:mm:ss): "),
      checkboxInput('first_run', 'First run?'),
      passwordInput("password", "Enter Password: "),
      actionButton("add_run", "Add Run!")
    )
)