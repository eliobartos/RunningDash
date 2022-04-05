
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


# Tables ------------------------------------------------------------------

get_top_runners = function(data) {
  
  tmp = data %>% 
    group_by(runner) %>% 
    summarise(
      total_distance = sum(distance) %>% round(2)
    ) %>% 
    arrange(desc(total_distance))
  
  tmp$final_string = ""
  
  if(nrow(tmp) >= 1) {
    tmp$final_string[1] = paste0("1st - ", tmp$total_distance[1], " km")
  }
  
  if(nrow(tmp) >= 2) {
    tmp$final_string[2] = paste0("2nd - ", tmp$total_distance[2], " km")
  }
  
  if(nrow(tmp) >= 3) {
    tmp$final_string[3] = paste0("3rd - ", tmp$total_distance[3], " km")
  }
  
  while(nrow(tmp) < 3) {
    empty_row = data.frame(runner = "Could be you!", total_distance = 0, final_string = "3rd - 0 km")
    tmp = bind_rows(tmp, empty_row)
  }
  
  return(tmp)
  
}
