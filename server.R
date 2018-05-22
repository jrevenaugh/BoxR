# server
#
# BoxR shiny server


server <- function(input, output, session) {

  # Reactives ------------------------------------------------------------------


  # Event Observers ------------------------------------------------------------


  # Main Panel -----------------------------------------------------------------

  # Pop up help panel
  observeEvent(input$help, {
    showModal(modalDialog(
      title = "Instructions",
      HTML(paste("Guide the red car around the track in as few moves as possible.",
                 "Your car's momentum dictates where you can go.  Click any",
                 "green circle to move.  Be sure to slow down before turns and avoid",
                 "the barricades (red circles).  If you crash, get back on the track",
                 "as quickly as possible and your car will (slowly) regain full throttle.",
                 tags$br(), tags$br(),
                 "You can undo as many moves as needed if you get in trouble,",
                 "but beware--the blue car keeps going.",
                 tags$br(), tags$br(),
                 "Justin Revenaugh", tags$br(),
                 "Earth Sciences", tags$br(),
                 "University of Minnesota", tags$br(),
                 "justinr@umn.edu", tags$br(),
                 "Code at: github.com/jrevenaugh/RacerX"
                )
      ),
      easyClose = TRUE)
    )
  })
}
