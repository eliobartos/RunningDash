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




