# Converts pace from minutes to pretty format mm:ss
minutes_to_ms = function(x) {
  paste0(floor(x), ':', round((x-floor(x)) * 60))
}