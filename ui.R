# UI
#
# Establish a bootstrapPage with game control widgets on the LHS
# and gameboard illustration filling page.

require(shiny)

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  plotOutput(outputId = "gamegrid",
             height = "100%",
             width = "100%",
             click = "click"),

  absolutePanel(top = 10, left = 10, width = "260px", draggable = FALSE,
                wellPanel(h4("BoxR V1.0"),
                          actionButton(inputId = "undo",
                                       label = "Undo",
                                       width = "100%",
                                       style = "margin-bottom: 5px;"),
                          actionButton(inputId = "reset",
                                       label = "New Race",
                                       width = "100%",
                                       style = "margin-bottom: 5px;"),
                          actionButton(inputId = "help",
                                       label = "Instructions",
                                       width = "100%"),
                          style = "opacity: 0.8; background:#FAFAFA;")
  )
)
