# server
#
# BoxR shiny server

source("plotting.R")
source("picker.R")

server <- function(input, output, session) {

  # Reactives ------------------------------------------------------------------
  grid <- reactiveValues(dots = NA,
                         nH = NA,
                         nV = NA,
                         nL = NA,
                         nB = NA,
                         centers = NA,
                         edges = NA,
                         boxes = NA,
                         centroids = NA,
                         b2e = NA)

  player <- reactiveValues(who = 1)
  score <- reactiveValues(p = rep(0, 2))
  lastLine <- reactiveVal(NA)

  # Event Observers ------------------------------------------------------------
  # Set up fresh grid if dimensions, # players, or reset is hit
  observeEvent(c(input$gRows, input$gCols, input$nPlayers, input$reset), {
    if (is.na(input$gRows) | is.na(input$gCols)) return()
    grid$dots <- expand.grid(x = seq(1, input$gCols) - 1, y = seq(1, input$gRows) - 1)
    grid$nH <- input$gRows * (input$gCols - 1)
    grid$nV <- input$gCols * (input$gRows - 1)
    grid$nB <- (input$gRows - 1) * (input$gCols - 1)
    grid$nL <- grid$nH + grid$nV

    grid$edges <- rep(FALSE, grid$nL)
    grid$boxes <- rep(0, (input$gRows - 1) * (input$gCols - 1))
    grid$centroids <- data.frame(x = rep(0, grid$nB), y = rep(0, grid$nB))
    grid$b2e <- matrix(0, nrow = grid$nB, ncol = 4)

    grid$centers <- data.frame(x = rep(0, grid$nL),
                               y = rep(0, grid$nL),
                               vert = rep(FALSE, grid$nL))

    # Build edge centers list
    for (i in 1:grid$nH) {
      grid$centers$x[i] <- (i - 1) %% (input$gCols - 1) + 0.5
      grid$centers$y[i] <- (i - 1) %/% (input$gCols - 1)
    }
    k <- i + 1
    for (i in 1:grid$nV) {
      grid$centers$y[k] <- (i - 1) %% (input$gRows - 1) + 0.5
      grid$centers$x[k] <- (i - 1) %/% (input$gRows - 1)
      grid$centers$vert[k] <- TRUE
      k <- k + 1
    }

    # Build box centroid list and box to edge hash matrix
    k <- 1
    for (j in 1:(input$gRows - 1)) {
      for (i in 1:(input$gCols - 1)) {
        grid$centroids$x[k] <- 0.5 + (i - 1)
        grid$centroids$y[k] <- 0.5 + (j - 1)
        grid$b2e[k,1] <- i + (j - 1) * (input$gCols - 1)
        grid$b2e[k,2] <- i + j * (input$gCols - 1)
        grid$b2e[k,3] <- grid$nH + j + (i - 1) * (input$gRows - 1)
        grid$b2e[k,4] <- grid$nH + j + i * (input$gRows - 1)
        k <- k + 1
      }
    }

    # Reset score and current player
    score$p <- rep(0, 2)
    player$who <- 1
    lastLine(NA)
  })

  # Pick an edge to draw
  observeEvent(input$click,{
    l <- whichEdge(grid$centers, input$click)
    if (grid$edges[l] == TRUE) return()
    grid$edges[l] <- TRUE
    lastLine(l)

    # Check for four sided boxes and attribute score(s) if any
    scored <- FALSE
    for (i in 1:grid$nB) {
      if (grid$boxes[i] == 0) {
        if (sum(grid$edges[grid$b2e[i,1:4]]) == 4) {
          grid$boxes[i] <- player$who
          score$p[player$who] <- score$p[player$who] + 1
          scored <- TRUE
        }
      }
    }
    if (!scored) player$who <- nextTurn[player$who]
  })

  # Undo a edge draw (maybe)
  observeEvent(input$dblclick,{
    if (is.na(lastLine())) return()
    l <- whichEdge(grid$centers, input$dblclick)
    if (l == lastLine()) {
      grid$edges[l] <- FALSE
      lastLine(NA)
      scored <- FALSE
      for (i in 1:grid$nB) {
        if (any(grid$b2e[i,] == l)) {
          if (grid$boxes[i] > 0) {
            scored <- TRUE
            score$p[grid$boxes[i]] <- score$p[grid$boxes[i]] - 1
            grid$boxes[i] <- 0
          }
        }
      }
      if (!scored) player$who <- nextTurn[player$who]
    }
  })


  # Graphics Renderers ---------------------------------------------------------
  # Main grid
  output$gamegrid <- renderPlot({
    g <- ggplot() + theme_void() + coord_equal()
    g <- plotBoxes(g, grid$centroids, grid$boxes)
    g <- plotEdges(g, grid$centers, grid$edges)
    g <- plotDots(g, grid$dots)

    g
  })

  # Score
  output$scores <- renderPlot({
    g <- plotScores(score$p, grid$nB)
    g
  })

  # Turn indicator (put here in plot block despite being an observer)
  observeEvent(player$who, {
    output$turn <- renderPlot({
      g <- ggplot() +
        theme_void() + theme(legend.position = "none") +
        scale_x_continuous(expand = c(0, 0)) +
        annotate("rect", xmin = 0, xmax = 1, ymin = 0, ymax = 1,
                 fill = boxFill[player$who],
                 color = edgeColor,
                 size = pSize)
      g
    })
  })

  # Pop up help panel
  observeEvent(input$help, {
    showModal(modalDialog(
      title = "Instructions",
      HTML(paste("Players take turns drawing vertical or horizontal edges between dots.",
                 "The player who draws the fourth edge of a square scores one point",
                 "and goes again.",
                 "When all edges are drawn, the player with the most completed squares wins.",
                 tags$br(), tags$br(),
                 "Select edge to draw by placing cursor near midpoint and clicking.",
                 "Erase the last drawn edge by double clicking midpoint.",
                 tags$br(), tags$br(),
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
