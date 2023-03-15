library(shiny)

ui <- fluidPage(
  
  titlePanel("Démineur"),
 
  
  sidebarLayout(
    sidebarPanel(
      selectInput("Niveau", "Choisir un niveau:",
                  choices=c("Facile", "Moyen", "Difficile"),
                  selected = "Facile"),
      
      numericInput("n_rows", "Nombre de lignes ", value = 10, min = 1),
      numericInput("n_cols", "Nombre de colonnes", value = 10, min = 1),
      numericInput("n_mines", "Nombre de mines", value = 10, min = 1),
      actionButton("nouvelle partie ", "jouer "))

    
  ),
  
  mainPanel(
    fluidRow( 
      column(width = 12,
             h4("Cliquer sur la case pour connaître sa valeur"),
             h4("Cliquer sur la case pour mettre un drapeau"))
    ),
    
    fluidRow(
      column(width = 12,
             uiOutput("Grille_de_jeu"));

      
   mainPanel(
      fluidRow(
        column(width = 12, 
               div(id = "game_board"))
      

    )
  )
)




