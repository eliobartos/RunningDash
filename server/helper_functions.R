# Converts pace from minutes to pretty format mm:ss
minutes_to_ms = function(x) {
  paste0(floor(x), ':', round((x-floor(x)) * 60))
}

# Converts seconds to hh:mm:ss format for printing out
seconds_to_hms = function(x, include_zero_hours = FALSE) {
  
  hours = floor(x/3600)
  remaining = x - hours * 3600
  
  minutes = floor(remaining/60)
  remaining = remaining - minutes * 60
  
  seconds = round(remaining)
  
  hours = as.character(hours) %>% add_formatting_zero()
  minutes = as.character(minutes) %>% add_formatting_zero()
  seconds = as.character(seconds) %>% add_formatting_zero()
  
  if(hours == '00' && include_zero_hours == FALSE) {
    out = paste0(minutes, ':', seconds) 
  } else {
    out = paste0(hours, ':', minutes, ':', seconds) 
  }
    
  return(out)
}


# makes sure hours, minutes, seconds are 2 charaters long
# 13 stays 13, but 5 becomes 05
add_formatting_zero = function(x) {
    return(ifelse(nchar(x) == 1, paste0('0', x), x))
}

# To not use tibble print when printing data frame to console
print.tbl_df = function(...) {
  print.data.frame(...)
}

# Calculates optimal clustering based on L1 norm + alpha * (k-1)
# where k is the number of clusters
# Returns the same input data with additional columns: cluster, cluster_center, cluster_label
get_smart_clusters = function(data, alpha = 0.5, min_k = 1, max_k = 6) {
  set.seed(100)
  res = data.frame()
  
  max_k = min(max_k, length(data$distance))
  
  # Try each cluster number k and calculate error ------------------------------------------
  for(k in min_k:max_k) {
    tmp_data = data
    fit = amap::Kmeans(data$distance, centers = k, method = "manhattan")
    tmp_data$cluster = fit$cluster %>% as.character()
    
    centers_df = data.frame(cluster = as.character(1:nrow(fit$centers)), centers = fit$centers)
    tmp_data = merge(tmp_data, centers_df)
    
    cluster_error = tmp_data %>% 
      group_by(cluster) %>% 
      summarise(
        error = sum(abs(distance - centers))
      ) %>% 
      summarise(
        cluster_error = sum(error)
      ) %>% 
      unlist()
    
    names(cluster_error) = NULL
    
    alpha_error = alpha  * (k-1)
    
    out = data.frame(k = k, cluster_error = cluster_error, alpha_error = alpha_error, total_error = cluster_error + alpha_error)
    
    res = bind_rows(res, out)
  }
  
  # Choose the best k and apply it to data ----------------------------------
  final_k = which.min(res$total_error)
  
  fit = kmeans(data$distance, centers = final_k, algorithm = "Lloyd")
  data$cluster = fit$cluster %>% as.character()
  
  centers_df = data.frame(cluster = as.character(1:nrow(fit$centers)), cluster_center = fit$centers)
  
  labels_df = data %>% 
    group_by(cluster) %>% 
    summarise(
      cluster_label = paste0("[", round(min(distance), 2), ", ", round(max(distance), 2), "]")
    )
  
  data = merge(centers_df, data) %>% merge(labels_df)
  return(data)
}




