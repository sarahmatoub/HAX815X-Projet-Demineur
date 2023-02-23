library(shiny)

ui <- fluidPage(
  
  titlePanel("Jeu du démineur"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("Niveau", "Choisir un niveau:",
                  choices=c("Facile", "Moyen", "Difficile"),
                  selected = "Facile")
    ),
    
    mainPanel(
      fluidRow(
        column(width = 12,
               h4("Cliquer sur la case"),
               h4("Cliquer sur la case pour mettre un drapeau"))
      ),
      
      fluidRow(
        column(width = 12,
               uiOutput("Grille_de_jeu"))
      )
    )
  )
)