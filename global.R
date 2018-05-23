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
edgeSize <- 1.5
edgeColor <- "gray50"
pSize <- 0.75

pFactor <- factor(x = c(1, 2), levels = c(1, 2), labels = c("One", "Two"))

pPoly <- data.frame(x = c(0, 1, 1, 0, 0, 2, 3, 3, 2, 2),
                    y = c(0, 0, 85, 85, 0, 0, 0, 85, 85, 0),
                    p = rep(pFactor, each = 5))
