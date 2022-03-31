source('ui/overall.R')
source('ui/individual.R')
source('ui/input.R')
source('ui/sidebar.R')

ui = dashboardPage(skin = "blue",
   dashboardHeader(title = "RunDash"),
   dashboardSidebar(
     menu_sidebar
   ),
   dashboardBody(
     tabItems(
       tab_overall,
       tab_individual,
       tab_input
     )
   )
)