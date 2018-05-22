# UI
#
# Establish a sidebarPage with game control widgets on the LHS
# and gameboard illustration filling mainPanel

require(shiny)

ui <- fluidPage(
        tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
        titlePanel(title = HTML("<p style = \"font-size:20px\"> &nbsp</p>"),
                   windowTitle = "Dots and Boxes"),
        sidebarLayout(
          sidebarPanel(width = 3,
            h4("Grid Dimensions"),
                    fluidRow(
                      column(6,
                        numericInput(inputId = "grows",
                                     label = "Rows",
                                     min = 3, max = 10, step = 1,
                                     value = 4)
                      ),
                      column(6,
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
                    hr(),
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
                    style = "opacity: 0.8; background:#FAFAFA;"
          ),
          mainPanel(
            plotOutput(outputId = "gamegrid",
                       click = "click",
                       dblclick = "dblclick")
          )
        )
)
