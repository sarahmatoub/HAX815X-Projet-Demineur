library(shiny)
library(bslib)
library(shinyWidgets)
library(gridExtra)

thematic::thematic_shiny(font = "auto")
# Définir la dimension de la grille et le nombre de mines pour chaque dimension
board_dims <- list(facile = c(4, 4), moyen = c(12, 16), difficile = c(20, 24))
mine_locs <- list(facile = sample(1:16, 4), moyen = sample(1:192, 40), difficile = sample(1:480, 99))

ui <- fluidPage(
  #theme = bs_theme(bootswatch = "minty", bg = "#558000", fg = "#fff", primary = "#d9f2d9", secondary = "#d9f2d9" ),
  tags$style('.well { background-color: #408000 ;}'),
  setBackgroundColor(color = "#004d00", direction = c("botom","top")),
  sidebarLayout(
    sidebarPanel(width="100 %",
                 fluidRow(
                   column(width = 4,
                          selectInput("Niveau", label = NULL,
                                      choices=c("Facile", "Moyen", "Difficile"),
                                      selected = "Facile")
                   ),
                   column(width = 4,
                          icon("flag", class = "fa-solid fa-flag-pennant", title = "Number of flags", lib = "font-awesome"),
                          tags$style(".fa-flag {color:#ff0000}"),  
                          tags$span(id = "num-flags", "0")
                   ),
                   column(width = 4,
                          icon("bomb",  class = "ml-2 mr-1", title = "Number of mines"),
                          tags$style(".fa-bomb {color:#000000 }"),
                          tags$span(id = "num-mines", "0"))),
    
   ),mainPanel(uiOutput("game_board"))
   
))


server <- function(input, output, session) {
 
  
  
   
}
  
   
shinyApp(ui=ui, server=server)
