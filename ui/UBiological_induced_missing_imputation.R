tabPanel("Biological Reason Induced Missing Imputation", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
                   fluidRow(
                     h2("total group missing mz"),
                     plotOutput("totalgroupmissedmz"),
                     hr(),
                     h2("missing due to low intensity mz"),
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

                     plotOutput("lowintensitymissing")
                   
                   
                  )
         )
)

