# plotDots
#
# Initiate a ggplot object with dot grid for BoxR dots and boxes game.

plotDots <- function(g, dots) {
  g <- g +
       geom_point(data = dots,
                  aes(x = x, y = y),
                  pch = 21,
                  size = dotSize,
                  color = "black",
                  fill = dotFill)

  g
}

plotEdges <- function(g, centers, edges) {
  # Loop over horizontal edges
  if (sum(edges) > 0) {
    A <- data.frame(x = NA, y = NA)
    for (i in seq_along(edges)) {
      if (edges[i]) {
        if (centers$vert[i]) {
          x <- rep(centers$x[i], 2)
          y <- c(centers$y[i] - 0.5, centers$y[i] + 0.5)
        } else {
          y <- rep(centers$y[i], 2)
          x <- c(centers$x[i] - 0.5, centers$x[i] + 0.5)
        }
        A <- rbind(A, data.frame(x = x, y = y))
        A <- rbind(A, data.frame(x = NA, y = NA))
      }
    }
    g <- g +
         geom_path(data = A,
                   aes(x = x, y = y),
                   color = edgeColor,
                   size = edgeSize)
  }
  g
}

plotBoxes <- function(g, centroids, boxes) {
  l1 <- which(boxes != 0)
  if (length(l1)) {
    for (i in l1) {
      p1 <- data.frame(xmin = centroids$x[i] - 0.5, xmax = centroids$x[i] + 0.5,
                       ymin = centroids$y[i] - 0.5, ymax = centroids$y[i] + 0.5)
      g <- g + geom_rect(data = p1,
                         aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
                         fill = boxFill[boxes[i]],
                         alpha = boxAlpha)
    }
  }
  g
}

plotScores <- function(scores, nB) {
  yScale <- 85 / nB
  pRect <- data.frame(xmin = c(0, 2), xmax = c(1, 3),
                      ymin = c(0, 0), ymax = scores * yScale,
                      col = pFactor)
  g <- ggplot() +
    theme_void() + theme(legend.position = "none") +
    scale_x_continuous(limits = c(0, 3)) +
    scale_y_continuous(limits = c(-15, 85)) +
    geom_rect(data = pRect,
              aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = col)) +
    geom_polygon(data = pPoly,
                 aes(x = x, y = y, group = p),
                 fill = NA,
                 color = edgeColor,
                 size = pSize) +

    scale_fill_manual(values = boxFill) +
    annotate("text", x = 0.5, y = -9, label = format(scores[1]), size = 5) +
    annotate("text", x = 2.5, y = -9, label = format(scores[2]), size = 5)
  g
}
