library(shiny)

ui <- fluidPage(
  titlePanel("Démineur"),
  sidebarPanel(
    selectInput("select", label = "Niveau", choices = list(" " ,"facile", "Moyen","Difficile"))
  )
  
)

