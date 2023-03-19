library(shiny)
library(Rbeast)

board_dims <- list(
  "Easy" = c(8, 8),
  "Medium" = c(16, 16),
  "Hard" = c(16, 30)
)

# mine_locs <- list(
#   "Easy" = 10,
#   "Medium" = 40,
#   "Hard" = 99
# )

#interface shiny  

ui <- fluidPage(
  titlePanel("Minesweeper"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Niveau", "Niveau",
                  choices = c("Easy", "Medium", "Hard"),
                  selected = "Easy")
    ),
    mainPanel(
      uiOutput("board_ui")
    )
  )
)

server <- function(input, output, session) {
  
  # Create game board
  board <- reactive({
    level <- input$Niveau
    dim <- board_dims[[level]]
    #mines <- mine_locs[[level]]
    
    # Generate game board using Rbeast::minesweeper function
    board_vec <- minesweeper(dim[1], dim[2], 0.15)
    board <- list(board = matrix(board_vec, nrow = dim[1], ncol = dim[2]))
    board
  })
  
  # Create UI for game board
  output$board_ui <- renderUI({
    board <- board()
    board_ui <- list()
    for (i in 1:nrow(board)) {
      row_ui <- list()
      for (j in 1:ncol(board)) {
        cell_ui <- actionButton(
          paste0("button_", i, "_", j),
          "",
          class = "btn btn-primary btn-sm game-button",
          style = "color: #ffffff; background-color: #007bff",
          onclick = sprintf("Shiny.setInputValue('cell_clicked', '%d,%d')", i, j)
        )
        row_ui <- c(row_ui, cell_ui)
      }
      board_ui <- c(board_ui, list(tags$div(class = "btn-group", row_ui)))
    }
    do.call(tags$div, c(board_ui, list(class = "game-board")))
  })
  
  # Handle cell clicks
  observeEvent(input$cell_clicked, {
    cell <- strsplit(input$cell_clicked, ",")[[1]]
    i <- as.numeric(cell[1])
    j <- as.numeric(cell[2])
    board_val <- board()[i, j]
    if (board_val == -1) {
      # Game over
      showModal(modalDialog(
        title = "Game Over",
        "You clicked on a mine! Game over.",
        footer = modalButton("Close")
      ))
    } else {
      # Update clicked cell
      cell_ui <- actionButton(
        paste0("button_", i, "_", j),
        if (board_val > 0) board_val else "",
        class = "btn btn-primary btn-sm game-button",
        style = "color: #ffffff; background-color: #28a745",
        disabled = TRUE
      )
      board_ui <- output$board_ui
      board_ui[[i]][[j]] <- cell_ui
      output$board_ui <- renderUI(do.call(tags$div, c(board_ui, list(class = "game-board"))))
    }
  })
}

shinyApp(ui, server)
