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
