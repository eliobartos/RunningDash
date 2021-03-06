server = function(input, output) {

  data_all = read_and_process_data()

  min_date_all = min(data_all$date)

  data = reactive({
    filter_data(data_all, input$date_filter)
  })

  min_date = reactive({
    get_min_date(min_date_all, input$date_filter)
  })

  output$runner_filter = renderUI({
    runners =  data()$runner %>% unique()
    selectInput("runner_filter",
                label = "Runner:",
                choices = runners,
                selected = runners[1])
  })

  data_runner = reactive({
    filter_data(data_all,  input$date_filter, input$runner_filter)
  })

  # Overall Tab ----------------------------------------------------------
  boxes_runner = reactive({
    get_top_runners(data())
  })

  output$first_runner = renderValueBox({
    valueBox(boxes_runner()$runner[1], boxes_runner()$final_string[1], icon = icon("trophy"), color = "orange")
  })

  output$second_runner = renderValueBox({
    valueBox(boxes_runner()$runner[2], boxes_runner()$final_string[2], icon = icon("play"), color = "green")
  })

  output$third_runner = renderValueBox({
    valueBox(boxes_runner()$runner[3], boxes_runner()$final_string[3], icon = icon("play"), color = "blue")
  })

  output$pace_vs_distance = renderPlotly({ graph_pace_vs_distance(data()) })

  output$avg_pace = renderPlotly({ graph_avg_pace(data()) })

  output$overall_table = renderFormattable({ overall_table(data()) })

  # Individual Tab ----------------------------------------------------------

  boxes = reactive({
    get_individual_stats(data_runner())
    })

  output$total_runs_ind = renderValueBox({
    valueBox(boxes()["total_runs"], "Total runs", icon = icon("hashtag"), color = "yellow")
  })

  output$total_distance_ind = renderValueBox({
    valueBox(boxes()["total_distance"], "Total distance", icon = icon("play"), color = "blue")
  })

  output$total_time_ind = renderValueBox({
    valueBox(boxes()["total_time"], "Total running time", icon = icon("clock"), color = "green")
  })

  output$avg_pace_ind = renderValueBox({
    valueBox(boxes()["avg_pace"], "Average pace", icon = icon("redo"), color = "orange")
  })

  output$distance_vs_run = renderPlotly({ graph_distance_vs_run(data_runner(), min_date()) })

  output$pace_vs_run = renderPlotly({ graph_pace_vs_run(data_runner(), min_date()) })

  output$distance_vs_date = renderPlotly({ graph_distance_vs_date(data_runner(), min_date()) })


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
