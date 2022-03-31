
# Returns runs table from DB
read_and_process_data = function() {
  data_all = dbGetQuery(db, "select * from runs") %>% 
    as.data.frame()
  
  data_all = data_all %>% 
    mutate(
      time_s = as.numeric(hms(time)),
      pace = time_s/distance/60,
      pace_pretty = minutes_to_ms(pace)
    )
  
  return(data_all)
}


# Receives: input$date_filter
# Returns: All runs data filtered to specific time period
filter_data = function(data_all, date_filter) {
  
  if(date_filter == 'Last 30 Days') {
    return(data_all %>% filter(date >= today() - 31))
  } else {
    return(data_all)
  }
  
}
