
# Graphs ------------------------------------------------------------------
graph_pace_vs_distance = function(data) {
  
  plot_ly(data = data, x = ~distance, y = ~pace, color =~runner,
          marker = list(size = 10)) %>% 
    layout(
      xaxis = list(rangemode = "tozero", zeroline = FALSE), 
      yaxis = list(rangemode = "tozero", zeroline = FALSE))
}


graph_avg_pace = function(data) {
  tmp = data %>% 
    mutate(
      distance_group = cut(distance, breaks = c(0, seq(0.5, 100.5, by = 1), Inf), labels = c(0, seq(1, 100, by = 1), 101)) %>% as.character() %>%  as.numeric()
    ) %>% 
    group_by(runner, distance_group) %>% 
    summarise(
      time = sum(time_s),
      distance_ = sum(distance),
      avg_pace = sum(time_s)/sum(distance)/60,
      avg_pace_pretty = minutes_to_ms(avg_pace)
    )
  
  plot_ly(data = tmp, x = ~distance_group, y =~ avg_pace, color =~runner, type = 'scatter',
          marker = list(size = 10)) %>% 
    layout(
      xaxis = list(rangemode = "tozero", zeroline = FALSE), 
      yaxis = list(rangemode = "tozero", zeroline = FALSE)
    )
}


# Tables ------------------------------------------------------------------
overall_table = function(data) {
   out = data %>% 
    group_by(runner) %>% 
    summarise(
      total_runs = n(),
      total_distance = sum(distance) %>% round(2),
      total_running_time = sum(time_s) %>% seconds_to_hms(),
      avg_distance = mean(distance) %>% round(2),
      avg_running_time = mean(time_s) %>% seconds_to_hms(),
      avg_pace = (sum(time_s)/sum(distance)) %>% seconds_to_hms()
    ) %>% 
     arrange(desc(total_distance))
   
   colnames(out) = c("Runner", "Runs", "Distance (km)", "Running Time", "Avg. Distance (km)", "Avg. Running Time", "Avg. Pace")

   return(out %>% formattable())   
}
