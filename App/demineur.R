library(shiny)
library(gridExtra)
library(shinyjs)
library(emojifont)
library(grid)


#Initialisation
rows = 6
cols = 8
mines = 10

#Remplacer les cases avec des -1 avec des emojis bombes
#bomb_url <- "https://em-content.zobj.net/thumbs/240/whatsapp/326/bomb_1f4a3.png"
#bomb_path <- "~/HAX815X-Projet-Demineur/image/bomb.png"

replace <- function(x){
  color <- c("#99ff33", "#b3ff66", "#b3d9ff", "#cc99ff", "#ff99cc")
  if(x==-1){
    return(emoji("bomb"))
  } else{
    return(text("x", col=color))
  }
}

# Générer une grille de démineur
generate_grid <- function(rows, cols, mines) {
  grid <- matrix(0, nrow = rows, ncol = cols) 
  mine_spots <- sample(1:(rows*cols), mines)
  grid[mine_spots] <- -1

  for (r in 1:rows) {
    for (c in 1:cols) {
      if (grid[r, c] == -1) {

        grid[r, c]  <- "M"
        #tags$image(src=bomb_url, width="0.1cm", height="0.1cm")

        grid[r, c] <- "M"

        next
      }
      neighbors <- c()
      if (r > 1) {
        neighbors <- c(neighbors, grid[r - 1, c])
        if (c > 1) {
          neighbors <- c(neighbors, grid[r - 1, c - 1])
        }
        if (c < cols) {
          neighbors <- c(neighbors, grid[r - 1, c + 1])
        }
      }
      if (r < rows) {
        neighbors <- c(neighbors, grid[r + 1, c])
        if (c > 1) {
          neighbors <- c(neighbors, grid[r + 1, c - 1])
        }
        if (c < cols) {
          neighbors <- c(neighbors, grid[r + 1, c + 1])
        }
      }
      if (c > 1) {
        neighbors <- c(neighbors, grid[r, c - 1])
      }
      if (c < cols) {
        neighbors <- c(neighbors, grid[r, c + 1])
      }
      grid[r, c] <- sum(neighbors == -1)
   
      if(grid[r,c]==0){
        grid[r,c] <- ""
      }
    }
  }
  return(grid)
  
}



# Fonction pour révéler la case sélectionnée
reveler_case <- function(grid, r, c) {
  if (grid[r, c] == "M") {
    # Si toutes les cellules contiennent une mine alors afficher game over
    grid[grid == "M"] <- emojifont::emoji("bomb")
    print(grid)
    print("Game over!")
  } else if (grid[r, c] == "") {
    # si la case est vide alors révéler les cellules adjacentes ne contenant pas de mines
    for (i in -1:1) {
      for (j in -1:1) {
        if (r+i >= 1 && r+i <= nrow(grid) && c+j >= 1 && c+j <= ncol(grid)) {
          if (grid[r+i, c+j] != "M" && grid[r+i, c+j] != "R") {
            grid[r+i, c+j] <- "R"
            grid <- reveler_case(grid, r+i, c+j)
          }
        } 
      }
    }
  }
  grid[r, c] <- "R"
  return(grid)
}

# Crée l'application Shiny
ui <- fluidPage(
  titlePanel("Jeu du démineur"),
  sidebarLayout(
    sidebarPanel(
      useShinyjs(),
      selectInput("Niveau", "Choisir un niveau",
                  choices = c("Facile", "Moyen", "Difficile"),
                  selected = "Facile"),
      actionButton("Valider", icon("fas fa-magic"), label="Valider")
    ),
    mainPanel(
       plotOutput("grid")
    )
  )
)

server <- shinyServer(function(input, output) {
    
    ma_gr <- eventReactive(input$Valider, {
    niveau <- input$Niveau
    
    grid <- matrix(0, nrow = rows, ncol = cols)
    mine_spots <- sample(1:(rows * cols), mines)
    grid[mine_spots] <- -1
    
    for (r in 1:rows) {
      for (c in 1:cols) {
        if (grid[r, c] == -1) {
          next
        }
        neighbors <- c()
        if (r > 1) {
          neighbors <- c(neighbors, grid[r - 1, c])
          if (c > 1) {
            neighbors <- c(neighbors, grid[r - 1, c - 1])
          }
          if (c < cols) {
            neighbors <- c(neighbors, grid[r - 1, c + 1])
          }
        }
        if (r < rows) {
          neighbors <- c(neighbors, grid[r + 1, c])
          if (c > 1) {
            neighbors <- c(neighbors, grid[r + 1, c - 1])
          }
          if (c < cols) {
            neighbors <- c(neighbors, grid[r + 1, c + 1])
          }
        }
        if (c > 1) {
          neighbors <- c(neighbors, grid[r, c - 1])
        }
        if (c < cols) {
          neighbors <- c(neighbors, grid[r, c + 1])
        }
        grid[r, c] <- sum(neighbors == -1)
      }
    }
    grid
    
  })
  
  
  #Affichage de la grille
    output$grid <- renderPlot({
    grid <- ma_gr()
   
    #couleurs des grilles
    theme1 <- ttheme_default(
      core = list(
        bg_params = list(fill = c("#fff2e6", "#ffe6cc"), col = "#ffcc99"), 
        fg_params = list(col = "blue")),
        base_size = 16)
    
    if (input$Niveau == "Facile") {
      matrix_output = generate_grid(6, 8, 10)
      grid.table(matrix_output, theme = theme1)
    }
    
    if (input$Niveau == "Moyen") {
      matrix_output = generate_grid(14, 18, 35)
      grid.table(matrix_output, theme = theme1)
    }
    
    if (input$Niveau == "Difficile") {
      matrix_output = generate_grid(18, 21, 60)
      grid.table(matrix_output, theme = theme1)
    }
   
    
    #grid.table(matrix_output, theme = ttheme_default(base_size = 10))
  })
})



shinyApp(ui = ui, server = server)