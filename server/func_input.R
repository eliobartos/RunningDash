validate_data = function(data_all, runner_name, run_date, run_distance, run_time, first_run, password) {
  
  runners = unique(data_all$runner)
  run_time = format(run_time, format = '%H:%M:%S')
  run_time_s = as.numeric(hms(run_time))
  pace = run_time_s/run_distance/60
  success_text = "Run added. Thank you! :*"
  
  if(runner_name == "") {
    notif_text = "Enter runner name!"
  } else if(run_distance < 0 || run_distance > 42) {
    notif_text = paste0("I don't believe you ran ", run_distance, " km.")
  } else if(run_distance < 0.5) {
    notif_text = paste0("You didn't manage to run more than", run_distance, " km?")
  } else if(run_time_s > 14400) {
    notif_text = paste0("You didn't run for that long!")
  } else if(run_time_s < 60) {
    notif_text = paste0("You ran less than a minute... That is not a run.")
  } else if(first_run == TRUE && runner_name %in% runners) {
    notif_text = "Runner name already taken!"
  } else if(first_run == FALSE && !(runner_name %in% runners)) {
    notif_text  = "Wrong runner name! If you are a new runner click on the checkbox, if not check entered runner name for mistakes."   
  } else if (pace < 3) {
    notif_text = "Your pace seems suspiciously fast, not allowing it!"
  } else if (pace > 13) {
    notif_text = "Your pace seems too slow. Did you run at all? Walking only does not count!"
  } else {
    notif_text = success_text
  }
  
  if(notif_text != success_text) {
    showNotification(notif_text, type = "error", duration = 10)
  }  else {
    showNotification("Adding run, please wait...")
    # Code to add it to db
    
    showNotification(notif_text, duration = 10, action = a(href = "javascript:location.reload();", "Reload page"))
  }
}
