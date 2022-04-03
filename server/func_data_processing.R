
# Returns runs table from DB
read_and_process_data = function() {
  data_all = tbl(db, 'runs') %>%
    as.data.frame()

  data_all = data_all %>%
    mutate(
      time_s = as.numeric(hms(time)),
      pace = time_s/distance/60,
      pace_pretty = minutes_to_ms(pace)
    )

  return(data_all)
}


# Receives: input$date_filter, input$runner_filter (optional)
# Returns: All runs data filtered to specific time period
filter_data = function(data_all, date_filter, runner_filter = NA) {

  if(date_filter == 'Last 30 Days') {
    data_all = data_all %>% filter(date >= today() - 31)
  }

  if(!is.na(runner_filter)){
    data_all = data_all %>% filter(runner == runner_filter)
  }

  return(data_all)
}
