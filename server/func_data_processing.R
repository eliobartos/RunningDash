
# Returns runs table from DB
read_and_process_data = function() {
  data_all = tbl(db, 'runs') %>%
    as.data.frame()

  data_all = data_all %>%
    mutate(
      time_s = as.numeric(hms(time)),
      pace_s = time_s/distance,
      pace = time_s/distance/60,
      pace_pretty = seconds_to_hms(pace_s)
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

# Returns relative min date based on input$date_filter and min date in data_all
get_min_date = function(min_date_all, date_filter){
  if(date_filter == 'Last 30 Days'){
    min_date = max(min_date_all, today() - 31)
  }else{
    min_date = min_date_all
  }

  return(min_date)
}
