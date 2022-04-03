graph_distance_vs_run = function(data_runner) {
  data_runner_sorted = data_runner %>% arrange(date) %>% mutate(run = 1:nrow(data_runner))

  plot_ly(data = data_runner_sorted, x = ~run, y = ~distance, color = 'rgb(129, 222, 199)',
          type = "bar") %>%
    layout(
      xaxis = list(rangemode = "tozero", zeroline = FALSE),
      yaxis = list(rangemode = "tozero", zeroline = FALSE))
}

graph_pace_vs_run = function(data_runner) {
  data_runner_sorted = data_runner %>% arrange(date) %>% mutate(run = 1:nrow(data_runner))

  plot_ly(data = data_runner_sorted, x = ~run, y = ~pace, color = 'rgb(129, 222, 199)',
          type = "bar") %>%
    layout(
      xaxis = list(rangemode = "tozero", zeroline = FALSE),
      yaxis = list(rangemode = "tozero", zeroline = FALSE))
}


graph_distance_vs_date = function(data_runner) {
  plot_ly(data = data_runner, x = ~date, y = ~distance, color = 'rgb(129, 222, 199)',
          type = "bar") %>%
    layout(
      xaxis = list(rangemode = "tozero", zeroline = FALSE),
      yaxis = list(rangemode = "tozero", zeroline = FALSE))
}
