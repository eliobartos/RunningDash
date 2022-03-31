source('ui/ui_overall.R')
source('ui/ui_individual.R')
source('ui/ui_input.R')
source('ui/ui_sidebar.R')

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