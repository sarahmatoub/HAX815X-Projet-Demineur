# Define UI for miles per gallon app ----
ui <- pageWithSidebar(
  
  # App title ----
  titlePanel("Jeu du démineur"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    
    # Input: Selector for variable to plot against mpg ----
    selectInput("select", label = h3("Choisir un niveau"),
                choices = list(" ", "Facile", "Moyen", "Difficile")
                  ),
    
  ),
  
  # Main panel for displaying outputs ----
  mainPanel()
)