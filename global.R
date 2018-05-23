require(tidyverse)

# Are you threatening me?
options(warn = -1)

# Bookkeeping
nextTurn <- c(2, 1)

# Graphics settings
boxFill <- c("dodgerblue", "orangered")
boxAlpha <- 0.2
dotSize <- 4
dotFill <- "gray50"
lineSize <- 1.5
lineColor <- "gray50"

pFactor <- factor(x = c(1, 2), levels = c(1, 2), labels = c("One", "Two"))

