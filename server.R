# server
#
# BoxR shiny server


server <- function(input, output, session) {

  # Reactives ------------------------------------------------------------------


  # Event Observers ------------------------------------------------------------


  # Main Panel -----------------------------------------------------------------

  # Pop up help panel
  observeEvent(input$help, {
    showModal(modalDialog(
      title = "Instructions",
      HTML(paste("Players take turns drawing vertical or horizontal lines between dots.",
                 "The player who draws the fourth side of a small squares scores one point",
                 "and goes again.",
                 "When all lines are drawn, the player with the most completed squares wins.",
                 tags$br(), tags$br(),
                 "Select sides to draw by placing cursor near midpoint and clicking.",
                 "Erase the last line drawn with the Undo button.",
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
