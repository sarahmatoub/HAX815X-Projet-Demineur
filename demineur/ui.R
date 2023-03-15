
library(shiny)
ui <- fluidPage(
  titlePanel("Minesweeper Game"),
  sidebarLayout(
    sidebarPanel(
      actionButton("flag_btn", icon("flag"), style = "color: blue;"),
      actionButton("bomb_btn", icon("bomb"), style = "color: red;"),
      p("Timer:"),
      h1(id = "displayTime", "00:00"),
      selectInput("Niveau", "Choisir un niveau:",
                  choices=c("Facile", "Moyen", "Difficile"),
                  selected = "Facile"),
      numericInput("n_rows", "Nombre de lignes ", value = 10, min = 1),
      numericInput("n_cols", "Nombre de colonnes", value = 10, min = 1),
      numericInput("n_mines", "Nombre de mines", value = 10, min = 1),
      actionButton("new_game", "New Game"),
      div(class = "btn-group", role = "group", style = "margin-top: 10px;",
          
      ),
      
    ),
    mainPanel(
      div(id = "board", class = "board")
    )
  )
)
server <- function(input, output, session){
}
# Run the application 
shinyApp(ui = ui, server = server)
