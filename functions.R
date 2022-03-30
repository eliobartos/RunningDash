

data = dbGetQuery(db, "select * from runs") %>% 
  as.data.frame()



get_top_distance_runner = function(rank) {
  
  tmp = data %>% 
    group_by(runner) %>% 
    summarise(
      total_distance = sum(distance)
  ) %>% 
    arrange(desc(total_distance))
  
  return(tmp[rank,])
  
  
}



data = data %>% 
  mutate(
    time_s = as.numeric(hms(time)),
    pace = time_s/distance/60,
    pace_pretty = minutes_to_ms(pace)
  )



plot_ly(data = data, x = ~distance, y =~ pace, color =~runner,
        marker = list(size = 10)) %>% 
  layout(
    xaxis = list(rangemode = "tozero", zeroline = FALSE), 
    yaxis = list(rangemode = "tozero", zeroline = FALSE))



# Converts pace from minutes to pretty format mm:ss
minutes_to_ms = function(x) {
  paste0(floor(x), ':', round((x-floor(x)) * 60))
}



%>% tmp = data %>% 
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
    yaxis = list(rangemode = "tozero", zeroline = FALSE))





