menu_sidebar = sidebarMenu(
  selectInput(
    'date_filter', 'Period:', 
    choices = c('Last 30 Days', 'All Time'), 
    selected = 'Last 30 Days'
  ),
  menuItem("Overall", tabName = "overall", icon = icon("globe")),
  menuItem("Individual Progress", tabName = "individual", icon = icon("globe")),
  menuItem("Add new run", tabName = "input", icon = icon("pencil-square-o"))
)