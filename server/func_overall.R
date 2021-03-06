
# Graphs ------------------------------------------------------------------
graph_pace_vs_distance = function(data) {
  
  hover_data = list()
  for(i in 1:nrow(data)) {
      hover_data[[i]] = paste0(
        "<b>Runner:</b>   ", data$runner[i], "\n",
        "<b>Distance:</b> ", data$distance[i], " km", "\n",
        "<b>Pace:</b>       ", data$pace_pretty[i], "\n",
        "<b>Date:</b>        ", data$date[i]
      )
  }
  
  data$hover_data = hover_data
  
  p = data %>% 
    ggplot(aes(x = distance, y = pace, color = runner)) +
    geom_point() +
    xlab("Distance (km)") +
    ylab("Pace (min/km)") +
    expand_limits(y = 4, x = 1) +
    scale_x_continuous(breaks = seq(2, 100, 2)) +
    scale_y_continuous(n.breaks = 6) +
    labs(color = "Runner") +
    theme_minimal() 
  
  p2 <- ggplotly(p)
  
  p2 <- p2 %>% layout(hoverlabel = list(align = "left"))
  
  fig = plotly_build(p2)
  
  for(i in 1:length(unique(data$runner))) {
    tmp = data %>% filter(runner == fig$x$data[[i]]$name)
    fig$x$data[[i]]$text = tmp$hover_data
  }

  return(fig)
  
}






graph_avg_pace = function(data) {
  
  data = get_smart_clusters(data, max_k = 10)
  
  tmp = data %>% 
    group_by(runner, cluster, cluster_center, cluster_label) %>% 
    summarise(
      time = sum(time_s),
      runs = n(),
      avg_distance = mean(distance),
      distance_ = sum(distance),
      avg_pace_s = sum(time_s)/sum(distance),
      avg_pace = sum(time_s)/sum(distance)/60,
      avg_pace_pretty = seconds_to_hms(avg_pace_s)
    )
  
  hover_data = list()
  for(i in 1:nrow(tmp)) {
    hover_data[[i]] = paste0(
      "<b>Runner:    </b>", tmp$runner[i], "\n",
      "<b>Runs:        </b>", tmp$runs[i], "\n",
      "<b>Distance Mean:  </b>", tmp$avg_distance[i] %>% round(2), " km", "\n",
      "<b>Distance Range: </b>", tmp$cluster_label[i], "\n",
      "<b>Avg Pace: </b>", tmp$avg_pace_pretty[i]
    )
  }
  
  tmp$hover_data = hover_data
  
  p = tmp %>% 
    ggplot(aes(x = cluster_center, y = avg_pace, color = runner)) +
    geom_vline(xintercept = unique(tmp$cluster_center), lty = 2, lwd = 0.4, alpha = 0.5, color = "red") +
    geom_point(alpha = 0.8, size = 2.5, shape = 15) +
    xlab("Distance Group") +
    ylab("Avg. Pace") +
    expand_limits(y = 4, x = 1) +
    scale_x_continuous(breaks = seq(2, 100, 2), minor_breaks = NULL) +
    scale_y_continuous(n.breaks = 6, minor_breaks = NULL) +
    labs(color = "Runner") +
    theme_minimal()
    
  p
  
  
  p2 <- ggplotly(p)
  
  p2 <- p2 %>% layout(hoverlabel = list(align = "left"))
  
  fig = plotly_build(p2)
  
  for(i in 1:length(unique(tmp$runner))) {
    tmp2 = tmp %>% filter(runner == fig$x$data[[i+1]]$name)
    fig$x$data[[i+1]]$text = tmp2$hover_data
  }
  
  return(fig)
  
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
