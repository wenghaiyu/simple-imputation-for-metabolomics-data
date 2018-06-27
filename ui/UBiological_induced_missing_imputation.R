tabPanel("Biological Reason Induced Missing Imputation", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
                   fluidRow(
                     h2("Usage:"),
                     p("In this step, the total group missing and the low abundance induced missing would be recongized and replaced witha minimum value."),
                     p("Why total group missing?"),
                     p("The total group missing is more likely to be caused by experimental design or low abundance of the metabolite."),
                     p("How to recongize low abundance induced missing?"),
                     p("If the abundance of a specific feature is similar to the detection limit, the proportion of missing would be relatively large, and the observed value would be relatively samll."),
                     hr(),
                     h2("total group missing mz"),
                     p("In the figure below, the observed value is marked green, the total group missing is marked red and the other missing is marked blue "),
                     plotOutput("totalgroupmissedmz"),
                     hr(),
                     h2("missing due to low intensity mz"),
                     p("please specifiy the missing ratio and the largest observed value. For a specific feature from specific biological group, if it contain more missing value than the threshold and the largeset observed value is smaller than the cutoff, it would be marked as low abundance induced missing"),
                     column(6,
                      sliderInput("misspercenthandling", "Percent of missing in each group",
                                   min = 0, max = 1, value = 0.5
                      )
                     ),
                     column(6,
                      sliderInput("lowquantile", "set a low intensity limit",
                                   min = 0, max = 0.1, value = 0.01
                      )
                     ),
                     p("In the figure below, the low abundance induced missing is marked red and the intensity of the observed value is represent by colour range"),
                     plotOutput("lowintensitymissing")
                   
                   
                  )
         )
)

