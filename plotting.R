# plotDots
#
# Initiate a ggplot object with dot grid for BoxR dots and boxes game.

plotDots <- function(g, dots) {
  g <- g +
       geom_point(data = dots,
                  aes(x = x, y = y),
                  pch = 21,
                  size = 4,
                  color = "black",
                  fill = "gray50")

  g
}

plotLines <- function(g, nrows, ncols, dots, hLines, vLines) {
  # Loop over horizontal lines
  if (sum(hLines) > 0) {
    xA <- data.frame(x = NA, y = NA)
    for (i in seq_along(hLines)) {
      if (i %% ncols & hLines[i]) {
        xA <- rbind(xA, data.frame(x = c(dots$x[i], dots$x[i] + 1), y = rep(dots$y[i], 2)))
        xA <- rbind(xA, data.frame(x = NA, y = NA))
      }
    }
    print(xA)
    g <- g +
         geom_path(data = xA,
                   aes(x = x, y = y),
                   color = "gray50",
                   size = 1.5)
  }
  # Loop over vertical lines
  if (sum(vLines) > 0) {
    yA <- data.frame(x = NA, y = NA)
    for (i in seq_along(vLines)) {
      if (i %% nrows & vLines[i]) {
        yA <- rbind(yA, data.frame(x = rep(dots$x[i], 2), y = c(dots$y[i], dots$y[i] + 1)))
        yA <- rbind(yA, data.frame(x = NA, y = NA))
      }
    }
    print(yA)
    g <- g +
         geom_path(data = yA,
                   aes(x = x, y = y),
                   color = "gray50",
                   size = 1.5)
  }
  g
}

plotBoxes <- function(g, nrows, ncols, dots, boxes) {
  l1 <- which(boxes == 1)
  if (length(l1)) {
    for (i in l1) {
      p1 <- data.frame(xmin = dots$x[i], xmax = dots$x[i] + 1,
                       ymin = dots$y[i], ymax = dots$y[i] + 1)
      g <- g + geom_rect(data = p1,
                         aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
                         fill = "blue",
                         alpha = 0.2)
    }
  }
  l2 <- which(boxes == 2)
  if (length(l2)) {
    for (i in l2) {
      p2 <- data.frame(xmin = dots$x[i], xmax = dots$x[i] + 1,
                       ymin = dots$y[i], ymax = dots$y[i] + 1)
      g <- g + geom_rect(data = p2,
                         aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
                         fill = "red",
                         alpha = 0.2)
    }
  }
  g
}

