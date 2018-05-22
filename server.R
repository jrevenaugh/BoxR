# server
#
# BoxR shiny server

source("plotting.R")

server <- function(input, output, session) {

  # Reactives ------------------------------------------------------------------
  grid <- reactiveValues(dots = NA,
                         hLines = NA,
                         vLines = NA,
                         boxes = NA)

  # Event Observers ------------------------------------------------------------
  observeEvent(c(input$grows, input$gcols, input$reset), {
    grid$dots <- expand.grid(x = seq(1, input$gcols), y = seq(1, input$grows))
    grid$hLines <- rep(FALSE, input$grows * input$gcols)
    grid$vLines <- rep(FALSE, input$gcols * input$grows)
    grid$boxes <- rep(0, input$grows * input$gcols)
    grid$boxes[c(1,2)] <- 1
  })


  # Game Panel -----------------------------------------------------------------
  output$gamegrid <- renderPlot({
    g <- ggplot() + theme_void() + coord_equal()
    g <- plotBoxes(g, input$grows, input$gcols, grid$dots, grid$boxes)
    g <- plotLines(g, input$grows, input$gcols, grid$dots, grid$hLines, grid$vLines)
    g <- plotDots(g, grid$dots)

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
