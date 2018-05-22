# server
#
# BoxR shiny server

source("plotting.R")

server <- function(input, output, session) {

  # Reactives ------------------------------------------------------------------

  # Event Observers ------------------------------------------------------------


  # Game Panel -----------------------------------------------------------------
  output$gamegrid <- renderPlot({
    g <- plotDots(input$grows, input$gcols)
#    g <- g + plotLines()
#    g <- g + plotBoxes()

    g
  })

  # Pop up help panel
  observeEvent(input$help, {
    showModal(modalDialog(
      title = "Instructions",
      HTML(paste("Players take turns drawing vertical or horizontal lines between dots.",
                 "The player who draws the fourth side of a small squares scores one point",
                 "and goes again.",
                 "When all lines are drawn, the player with the most completed squares wins.",
                 tags$br(), tags$br(),
                 "Select side to draw by placing cursor near midpoint and clicking.",
                 "Erase the last line drawn by double clicking midpoint.",
                 "Justin Revenaugh", tags$br(),
                 "Earth Sciences", tags$br(),
                 "University of Minnesota", tags$br(),
                 "justinr@umn.edu", tags$br(),
                 "Code at: github.com/jrevenaugh/BoxR"
                )
      ),
      easyClose = TRUE)
    )
  })
}
