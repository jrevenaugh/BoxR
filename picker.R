# Pick an edge using click location and edge centers

whichEdge <- function(centers, click) {
  x <- click$x
  y <- click$y
  gDist <- sqrt((centers$x - x)^2 + (centers$y - y)^2)
  l <- which.min(gDist)
  return(l)
}
