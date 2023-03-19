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
  theme = bslib::bs_theme(
    # Controls the default grayscale palette
    bg = "#4e762f", fg = "#ffffff",
    # Controls the accent (e.g., hyperlink, button, etc) colors
    primary = "#a6d44d", secondary = "#ffffff",
    base_font = c("Grandstander", "sans-serif"),
    code_font = c("Courier", "monospace"),
    heading_font = "'Helvetica Neue', Helvetica, sans-serif",
    # Can also add lower-level customization
    "input-border-color" = "#bbff99"
  ),
  titlePanel(paste("Bienvenue au plateau de jeu du démineur", emojifont::emoji("smile"))),
  sidebarLayout(
    sidebarPanel(
      useShinyjs(),
      selectInput("Niveau", "Choisir un niveau",
                  choices = c("Facile", "Moyen", "Difficile"),
                  selected = "Facile"),
      fluidRow(
        column(width = 10, height=3, 
               actionButton("Valider", icon("check-circle", style = "color: #194d00;"), label="Valider")),
      hr(),
      numericInput('reveal', "Choisir la case à révéler :",
                   1, min = 1, max = 320),
      fluidRow(
        column(width = 12, height=3,
             actionButton("reveal", icon("fas fa-magic", style = "color: black"), label="Révéler")  
          )
      ),
      
      hr(),
      numericInput("flag", "Choisir la case où mettre un drapeau :",
                   1, min = 1, max = 320),
      fluidRow(
        column(width = 12, height=3, 
               actionButton(
                 "flag", icon("bomb"), label="Mettre/retirer un drapeau")
              )
      ),
      hr(),
      fluidRow(
        column(width=10,height=3, 
        actionButton(
        inputId = "replay",
        icon("refresh", style = "color: #4ce600;") ,
        label="Rejouer")
    )))),
    mainPanel(
       plotOutput("grid", width = "600px" , height="400px")
                  # click = "cell_reveal",
                  # dbclick = "flag_cell") # l'argument click est fait pour gérer les clicks (click et double click)
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
    
  # observeEvent(input$rightclick, {
  #   if (input$rightclick$value == "flag") {
  #     # update flag count
  #     flag_count <- input$flag_count + 1
  #     updateActionButton(session, "flag-count", label = paste0(emoji("triangular_flag_on_post"), flag_count))
  #   } else if (input$rightclick$value == "unflag") {
  #     # update flag count
  #     flag_count <- input$flag_count - 1
  #     updateActionButton(session, "flag-count", label = paste0(emoji("triangular_flag_on_post"), flag_count))
  #   }
  # })
  # 
  
  #Affichage de la grille
    output$grid <- renderPlot({
    grid <- ma_gr()
   
    #couleurs des grilles
    #theme grille cachée
    theme1 <- ttheme_default(
      core = list(
        bg_params = list(fill = c("#fff2e6", "#ffe6cc"), col = "#ffcc99"), 
        fg_params = list(col = "blue")),
        base_size = 16)
    
    #thème grille affichée
    theme2 <- ttheme_default(
      core = list(
        bg_params = list(fill = c("#ffe6cc", "#ffd9b3"), col = "#ffd3a3"), 
        fg_params = list(col = "#00334d")),
      base_size = 16, base_colour = "#005580")
    
      #générer une grille pour chaque niveau
    if (input$Niveau == "Facile") {
      matrix_output = generate_grid(6, 8, 10)
      matrix_hide = grid_cachee(matrix_output)
      grid.table(matrix_hide, theme=theme2)
    }
    
    if (input$Niveau == "Moyen") {
      matrix_output = generate_grid(14, 18, 35)
      matrix_hide = grid_cachee(matrix_output)
      grid.table(matrix_hide, theme = theme2)
    }
    
    if (input$Niveau == "Difficile") {
      matrix_output = generate_grid(16, 20, 60)
      matrix_hide = grid_cachee(matrix_output)
      grid.table(matrix_hide, theme = theme2)
    }
   
  })
    
   
   
   observeEvent(input$reveal, {
     row <- input$row
     col <- input$col
     grid <- input$matrix_output
     hidden_grid <- input$matrix_hide
     
     revealed_grid <- reveler_case(grid, row, col, hidden_grid)
     update_input(session, hidden_grid, value = revealed_grid)
   })
    
    
    
    # output$bombsleft <- renderText({
    #   paste0("Bombs left", mines_count(grid=matrix_output))
    # })
    
    
})



shinyApp(ui = ui, server = server)
