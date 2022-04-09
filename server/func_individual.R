graph_distance_vs_run = function(data_runner, min_date) {

  data_runner_sorted = data_runner %>% arrange(date) %>% mutate(run = 1:nrow(data_runner))
  max_run = max(data_runner_sorted$run) + 1

  hover_data = list()
  for(i in 1:nrow(data_runner_sorted)) {
      hover_data[[i]] = paste0(
        "<b>Distance:</b> ", data_runner_sorted$distance[i], " km", "\n",
        "<b>Time:</b>       ", data_runner_sorted$time_s[i] %>% seconds_to_hms(), "\n",
        "<b>Pace:</b>       ", data_runner_sorted$pace_pretty[i], "\n",
        "<b>Date:</b>        ", data_runner_sorted$date[i]
      )
  }

  p = data_runner_sorted %>%
    ggplot(aes(x = run, y = distance)) +
    geom_bar(stat="identity", fill="lightblue", width = 0.9) +
    xlab("Run #") +
    ylab("Distance (km)") +
    scale_x_continuous(
      limits = c(0, max_run),
      breaks = data_runner_sorted$run
      ) +
    theme_minimal()

  p2 = ggplotly(p) %>% layout(hoverlabel = list(align = "left"))

  fig = plotly_build(p2)

  fig$x$data[[1]]$text = hover_data

  return(fig)
}

graph_pace_vs_run = function(data_runner, min_date) {

  data_runner_sorted = data_runner %>% arrange(date) %>% mutate(run = 1:nrow(data_runner))
  max_run = max(data_runner_sorted$run) + 1

  hover_data = list()
  for(i in 1:nrow(data_runner_sorted)) {
      hover_data[[i]] = paste0(
        "<b>Distance:</b> ", data_runner_sorted$distance[i], " km", "\n",
        "<b>Time:</b>       ", data_runner_sorted$time_s[i] %>% seconds_to_hms(), "\n",
        "<b>Pace:</b>       ", data_runner_sorted$pace_pretty[i], "\n",
        "<b>Date:</b>        ", data_runner_sorted$date[i]
      )
  }

  p = data_runner_sorted %>%
    ggplot(aes(x = run, y = pace, group = 1)) +
    geom_point(size = 4, color ="orange") +
    geom_line(size = 1, color ="orange") +
    xlab("Run #") +
    ylab("Pace (min/km)") +
    scale_x_continuous(
      limits = c(0, max_run),
      breaks = data_runner_sorted$run
      ) +
    expand_limits(y = 4) +
    theme_minimal()

  p2 = ggplotly(p) %>% layout(hoverlabel = list(align = "left"))

  fig = plotly_build(p2)

  fig$x$data[[1]]$text = hover_data

  return(fig)
}


graph_distance_vs_date = function(data_runner, min_date) {

  hover_data = list()
  for(i in 1:nrow(data_runner)) {
      hover_data[[i]] = paste0(
        "<b>Distance:</b> ", data_runner$distance[i], " km", "\n",
        "<b>Pace:</b>       ", data_runner$pace_pretty[i], "\n",
        "<b>Date:</b>        ", data_runner$date[i]
      )
  }

  data_runner$hover_data = hover_data

  p = data_runner %>%
    ggplot(aes(x = date, y = distance)) +
    geom_bar(stat="identity", fill="lightblue", width = 0.9) +
    xlab("Date") +
    ylab("Distance (km)") +
    scale_x_date(
      date_breaks = "2 days",
      limits = c(min_date-1, today() + 1),
      date_labels = "%b %d"
      ) +
    theme_minimal()

  p2 = ggplotly(p) %>% layout(hoverlabel = list(align = "left"))

  fig = plotly_build(p2)

  fig$x$data[[1]]$text = hover_data

  return(fig)

}

get_individual_stats = function(data_runner) {
  total_runs = data_runner %>% nrow()
  total_distance = sum(data_runner$distance)
  total_time = sum(data_runner$time_s)
  avg_pace = (total_time/total_distance)

  return(list(
    total_runs = total_runs %>% as.character() ,
    total_distance = total_distance %>% as.character(),
    total_time = total_time %>% seconds_to_hms(),
    avg_pace = avg_pace %>% seconds_to_hms()))
}
