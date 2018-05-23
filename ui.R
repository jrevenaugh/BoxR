# UI
#
# Establish a sidebarPage with game control widgets on the LHS
# and gameboard illustration filling mainPanel

require(shiny)

ui <- fluidPage(
        tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
        titlePanel(title = "",
                   windowTitle = "Dots and Boxes"),
        sidebarLayout(
          sidebarPanel(width = 3,
            h4("Grid Dimensions"),
                    fluidRow(
                      column(6,
                        numericInput(inputId = "gRows",
                                     label = "Rows",
                                     min = 3, max = 11, step = 1,
                                     value = 4)
                      ),
                      column(6,
                        numericInput(inputId = "gCols",
                                     label = "Columns",
                                     min = 3, max = 11, step = 1,
                                     value = 4)
                      )
                    ),
                    radioButtons(inputId = "nPlayers",
                                 label = "Players",
                                 choices = c("One (play the computer)" = 1,
                                             "Two (play a friend)" = 2),
                                 selected = 2),
                    fluidRow(
                      column(6,
                        actionButton(inputId = "reset",
                                     label = "New Game",
                                     width = "100%",
                                     style = "margin-bottom: 5px;")
                      ),
                      column(6,
                        actionButton(inputId = "help",
                                     label = "Help",
                                     width = "100%",
                                     style = "margin-bottom: 5px;")
                      )
                    ),
                    hr(),
                    h5("Score", align = "center"),
                    plotOutput(outputId = "scores", width = "100%", height = "100px"),
                    h5("Turn", align = "center"),
                    plotOutput(outputId = "turn", width = "100%", height = "25px"),
                    style = "opacity: 0.8; background:#FAFAFA;"
          ),
          mainPanel(
            plotOutput(outputId = "gamegrid",
                       click = "click",
                       dblclick = "dblclick")
          )
        )
)
