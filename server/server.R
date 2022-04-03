server = function(input, output) {

  data_all = read_and_process_data()

  data = reactive({
    filter_data(data_all, input$date_filter)
  })

  output$runner_filter = renderUI({
    runners =  data()$runner %>% unique()
    selectInput("runner_filter",
                label = "Runner:",
                choices = runners,
                selected = runners[1] )
  })

  data_runner = reactive({
    filter_data(data_all,  input$date_filter, input$runner_filter)
  })

  # Overall Tab ----------------------------------------------------------

  output$first_runner = renderValueBox({
    valueBox("Anci", "1st - 30 km", icon = icon("trophy"), color = "orange")
  })

  output$second_runner = renderValueBox({
    valueBox("Elio", "2nd - 25 km", icon = icon("play"), color = "green")
  })

  output$third_runner = renderValueBox({
    valueBox("Hop", "3rd - 13 km", icon = icon("listfaet"), color = "navy")
  })

  output$pace_vs_distance = renderPlotly({ graph_pace_vs_distance(data()) })

  output$avg_pace = renderPlotly({ graph_avg_pace(data()) })
  
  output$overall_table = renderFormattable({ overall_table(data()) })

  # Individual Graphs ----------------------------------------------------------
  output$distance_vs_run = renderPlotly({ graph_distance_vs_run(data_runner()) })

  output$pace_vs_run = renderPlotly({ graph_pace_vs_run(data_runner()) })

  output$distance_vs_date = renderPlotly({ graph_distance_vs_date(data_runner()) })
 

  # Input -------------------------------------------------------------------

  observeEvent(input$add_run, {
    validate_data(
      data_all,
      input$runner_name,
      input$run_date,
      input$run_distance,
      input$run_time,
      input$first_run
    )
  })

}
