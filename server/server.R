server = function(input, output) {

  data_all = read_and_process_data()

  min_date_all = min(data_all$date)

  data = reactive({
    filter_data(data_all, input$date_filter)
  })

  min_date = get_min_date(min_date_all, input$date_filter)

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

  # Individual Tab ----------------------------------------------------------

  boxes = reactive({
    individual_boxes(data_runner())
    })

  output$total_runs_ind = renderValueBox({
    valueBox(boxes()["total_runs"], "Total runs", icon = icon("hashtag"), color = "orange")
  })

  output$total_distance_ind = renderValueBox({
    valueBox(boxes()["total_distance"], "Total distance", icon = icon("play"), color = "green")
  })

  output$total_time_ind = renderValueBox({
    valueBox(boxes()["total_time"], "Total running time", icon = icon("clock"), color = "yellow")
  })

  output$avg_pace_ind = renderValueBox({
    valueBox(boxes()["avg_pace"], "Average pace", icon = icon("redo"), color = "blue")
  })

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
