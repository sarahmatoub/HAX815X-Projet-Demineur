library(shiny)

ui <- fluidPage(
  titlePanel("Démineur"),
  sidebarPanel(
    selectInput("select", label =h3("Niveau") , choices = list("Null", "facile", "Moyen","Difficile")
                )
  )
  
)

