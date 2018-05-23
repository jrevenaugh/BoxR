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

plotLines <- function(g, centers, lines) {
  # Loop over horizontal lines
  if (sum(lines) > 0) {
    A <- data.frame(x = NA, y = NA)
    for (i in seq_along(lines)) {
      if (lines[i]) {
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
                   color = lineColor,
                   size = lineSize)
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

