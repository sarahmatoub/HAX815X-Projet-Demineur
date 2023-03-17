library(shiny)
library(gridExtra)

server <- function(input, output, session){
  
  Niveau <- eventReactive(input$Niveau)
  output$Grille_de_jeu <- renderPlot({ 
    
    #Définir la taille de la grille et le nombre de mines en fonction du niveau
    if (input$Niveau == "Facile"){
      n_rows <- 8
      n_cols <- 10
      n_mines <- 10
    } else if (input$Niveau == "Moyen") {
      n_rows <- 14
      n_cols <- 18
      n_mines <- 40
    } else {
      n_rows <- 20
      n_cols <- 24
      n_mines <- 99
    }
  })
  # Créer une grille vide
  grid$data <- matrix(0, n_rows, n_cols)
  
  # Générer des nombres de mines à des endroits aléatoires
  mine_end$data <- sample(n_rows * n_cols, n_mines)
  
  #Placer des mines dans la grille 
  grid$data[mine_end$data] <- -1
  
  #Boucle pour chaque cellule dans la grille
  for (i in 1:n_rows){
    for (j in 1:n_cols){
      #Vérifier s'il y a une mine dans la cellule
      if (grid$data[i,j]== -1){
        next #s'il y a une mine  passer à une autre cellule
      }
      #compter le nombre de mines voisines
      n_voisins <- sum(grid$data[max(1, i-1) : min(n_rows, i+1), max(1, j-1) : min(n_cols, j+1)] == -1)
      
      #définir la valeur de la cellule sur le nb de mines voisines
      grid$data[i,j] <- n_voisins
      
    }
  }
  
  #Définir la grille de jeu
  output$Grille_de_jeu <- renderUI({
    tags$table(id = "Grille", class = "Grille",
               lapply(1:n_rows, function(i) {
                 tags$tr(
                   lapply(1:n_cols, function(j) {
                     tags$td(
                       class = "case caché",
                       onclick = paste0("reveler_case(", i, ",", j, ")"),
                       oncontextmenu = paste0("drapeau_case(", i, ",", j, "); return false;")
                     )
                   })
                 )
               }))
  })
  # Définir la fonction qui révèle la case:
  reveler_case <- function(i, j){
    #Vérifier si la case a été révélée ou pas
    if(!hadClass(paste0("td[", i, ",", j, "]"), "caché")) {
      return()
    }
    
    #Supprimer la classe cachée de la case
    addClass(paste0("td[", i, ",", j, "]"), "révélée")
  }
  
}



