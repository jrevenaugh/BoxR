# server
#
# BoxR shiny server

source("plotting.R")

server <- function(input, output, session) {

  # Reactives ------------------------------------------------------------------
  grid <- reactiveValues(dots = NA,
                         nH = NA,
                         nV = NA,
                         nL = NA,
                         nB = NA,
                         centers = NA,
                         lines = NA,
                         boxes = NA,
                         centroids = NA,
                         b2l = NA)

  # Event Observers ------------------------------------------------------------
  # Set up fresh grid if dimensions or reset is hit
  observeEvent(c(input$grows, input$gcols, input$reset), {
    grid$dots <- expand.grid(x = seq(1, input$gcols) - 1, y = seq(1, input$grows) - 1)
    grid$nH <- input$grows * (input$gcols - 1)
    grid$nV <- input$gcols * (input$grows - 1)
    grid$nB <- (input$grows - 1) * (input$gcols - 1)
    grid$nL <- grid$nH + grid$nV

    grid$lines <- rep(FALSE, grid$nL)
    grid$boxes <- rep(0, (input$grows - 1) * (input$gcols - 1))
    grid$centroids <- data.frame(x = rep(0, grid$nB), y = rep(0, grid$nB))
    grid$b2l <- matrix(0, nrow = grid$nB, ncol = 4)

    grid$centers <- data.frame(x = rep(0, grid$nL),
                               y = rep(0, grid$nL),
                               vert = rep(FALSE, grid$nL))

    # Build line centers list
    for (i in 1:grid$nH) {
      grid$centers$x[i] <- (i - 1) %% (input$gcols - 1) + 0.5
      grid$centers$y[i] <- (i - 1) %/% (input$gcols - 1)
    }
    k <- i + 1
    for (i in 1:grid$nV) {
      grid$centers$y[k] <- (i - 1) %% (input$grows - 1) + 0.5
      grid$centers$x[k] <- (i - 1) %/% (input$grows - 1)
      grid$centers$vert[k] <- TRUE
      k <- k + 1
    }

    # Build box centroid list and box to line hash matrix
    k <- 1
    for (j in 1:(input$gcols - 1)) {
      for (i in 1:(input$grows - 1)) {
        grid$centroids$x[k] <- 0.5 + (i - 1)
        grid$centroids$y[k] <- 0.5 + (j - 1)
        grid$b2l[k,1] <- i + (j - 1) * (input$gcols - 1)
        grid$b2l[k,2] <- i + j * (input$gcols - 1)
        grid$b2l[k,3] <- grid$nH + j + (i - 1) * (input$gcols - 1)
        grid$b2l[k,4] <- grid$nH + j + i * (input$gcols - 1)
        k <- k + 1
      }
    }
    print(grid$centers)
    print(grid$centroid)
    print(grid$b2l)
  })

  # Pick a side
  observeEvent(input$click,{
    x <- input$click$x
    y <- input$click$y
    gDist <- sqrt((grid$centers$x - x)^2 + (grid$centers$y - y)^2)
    l <- which.min(gDist)
    grid$lines[l] <- TRUE

    # Check for four sides
    for (i in 1:grid$nB) {
      print(grid$lines[grid$b2l[i,1:4]])
      if (sum(grid$lines[grid$b2l[i,1:4]]) == 4) grid$boxes[i] <- TRUE
    }
  })


  # Game Panel -----------------------------------------------------------------
  output$gamegrid <- renderPlot({
    g <- ggplot() + theme_void() + coord_equal()
    g <- plotBoxes(g, grid$centroids, grid$boxes)
    g <- plotLines(g, input$grows, input$gcols, grid$centers, grid$lines)
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
