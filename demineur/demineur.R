library(shiny)
library(bslib)
library(shinyWidgets)

thematic::thematic_shiny(font = "auto")

ui <- fluidPage(
  #theme = bs_theme(bootswatch = "minty", bg = "#558000", fg = "#fff", primary = "#d9f2d9", secondary = "#d9f2d9" ),
  tags$style('.well { background-color: #408000 ;}'),
  setBackgroundColor(color = "#004d00", direction = c("botom","right")),
  sidebarLayout(
    sidebarPanel(width = "100 %",
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
    
   ),mainPanel()
    
))



server <- function(input, output, session) {
  
  
}

shinyApp(ui, server)
