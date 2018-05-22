# UI
#
# Establish a bootstrapPage with game control widgets on the LHS
# and gameboard illustration filling page.

require(shiny)

ui <- bootstrapPage(title = "BoxR v1.0 - Dots and Boxes",
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  plotOutput(outputId = "gamegrid",
             height = "100%",
             width = "100%",
             click = "click"),

  absolutePanel(top = 10, left = 10, width = "260px", draggable = TRUE,
                wellPanel(h4("Grid Dimensions"),
                          fluidRow(
                            column(5,
                              numericInput(inputId = "grows",
                                           label = "Rows",
                                           min = 3, max = 10, step = 1,
                                           value = 4)
                            ),
                            column(2),
                            column(5,
                              numericInput(inputId = "gcols",
                                           label = "Columns",
                                           min = 3, max = 10, step = 1,
                                           value = 4)
                            )
                          ),
                          radioButtons(inputId = "nPlayers",
                                       label = "Players",
                                       choices = c("One (play the computer)" = 1,
                                                   "Two (play a friend)" = 2),
                                       selected = 1),
                          actionButton(inputId = "reset",
                                       label = "New Game",
                                       width = "100%",
                                       style = "margin-bottom: 5px;"),
                          actionButton(inputId = "help",
                                       label = "Instructions",
                                       width = "100%"),
                          style = "opacity: 0.8; background:#FAFAFA;")
  )
)
