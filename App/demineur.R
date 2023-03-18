library(shiny)
library(gridExtra)
library(shinyjs)
library(shinyWidgets)
library(emojifont)
library(grid)

#Initialisation
rows = 6
cols = 8
mines = 10


# Interface utilisateur
ui <- fluidPage(
  titlePanel("Jeu du démineur"),
  sidebarLayout(
    sidebarPanel(
      useShinyjs(),
      selectInput("Niveau", "Choisir un niveau",
                  choices = c("Facile", "Moyen", "Difficile"),
                  selected = "Facile"),
      br(),
      
      fluidRow(
        column(width = 4, 
               actionButton("Valider", icon("check-circle", style = "color: green;"), label="Valider")),
      br(),
      fluidRow(
        column(width = 12, align = "center",
               actionBttn(
                 inputId = "bombsleft",
                 label = emoji("triangular_flag_on_post"),
                 style = "unite",
                 color = "primary",
                 size = "lg",
                 value = 0
               ))
      ),
      fluidRow(
        column(width=12, align="center",
        actionButton(
        inputId = "replay",
        icon("refresh", style = "color: blue;") ,
        label="Rejouer")
      
      
    )))),
    mainPanel(
       plotOutput("grid")
    )
  ))


server <- shinyServer(function(input, output) {
  source("functions.R")
  
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
    
  observeEvent(input$rightclick, {
    if (input$rightclick$value == "flag") {
      # update flag count
      flag_count <- input$flag_count + 1
      updateActionButton(session, "flag-count", label = paste0(emoji("triangular_flag_on_post"), flag_count))
    } else if (input$rightclick$value == "unflag") {
      # update flag count
      flag_count <- input$flag_count - 1
      updateActionButton(session, "flag-count", label = paste0(emoji("triangular_flag_on_post"), flag_count))
    }
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
   
  })
    
    # output$bombsleft <- renderText({
    #   paste0("Bombs left", mines_count(grid=matrix_output))
    # })
})



shinyApp(ui = ui, server = server)
