graph_distance_vs_run = function(data_runner) {
  data_runner_sorted = data_runner %>% arrange(date) %>% mutate(run = 1:nrow(data_runner))

  plot_ly(data = data_runner_sorted, x = ~run, y = ~distance, marker = list(color = 'rgb(158,202,225)'),
          type = "bar") %>%
    layout(
      xaxis = list(rangemode = "tozero", zeroline = FALSE),
      yaxis = list(rangemode = "tozero", zeroline = FALSE))
}

graph_pace_vs_run = function(data_runner) {
  data_runner_sorted = data_runner %>% arrange(date) %>% mutate(run = 1:nrow(data_runner))

  plot_ly(data = data_runner_sorted, x = ~run, y = ~pace, marker = list(color = 'rgb(158,202,225)'),
          type = "bar") %>%
    layout(
      xaxis = list(rangemode = "tozero", zeroline = FALSE),
      yaxis = list(rangemode = "tozero", zeroline = FALSE))
}


graph_distance_vs_date = function(data_runner) {
  plot_ly(data = data_runner, x = ~date, y = ~distance, marker = list(color = 'rgb(158,202,225)'),
          type = "bar") %>%
    layout(
      xaxis = list(rangemode = "tozero", zeroline = FALSE),
      yaxis = list(rangemode = "tozero", zeroline = FALSE))
}

individual_boxes = function(data_runner) {
  total_runs = data_runner %>% nrow()
  total_distance = sum(data_runner$distance)
  total_time = sum(data_runner$time_s)
  avg_pace = (total_time/total_distance)

  return(list(
    total_runs = total_runs %>% as.character() ,
    total_distance = total_distance %>% as.character(),
    total_time = total_time %>% seconds_to_hms(),
    avg_pace = round(avg_pace,2) %>% as.character()))
}
