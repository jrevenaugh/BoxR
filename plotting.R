# plotDots
#
# Initiate a ggplot object with dot grid for BoxR dots and boxes game.

plotDots <- function(nrow, ncol) {
  dots <- expand.grid(x = seq(1, ncol, 1), y = seq(1, nrow, 1))
  g <- ggplot() +
       coord_equal() +
       geom_point(data = dots,
                  aes(x = x, y = y),
                  pch = 21,
                  size = 4,
                  color = "black",
                  fill = "gray50") +
       theme_void()

  g
}
