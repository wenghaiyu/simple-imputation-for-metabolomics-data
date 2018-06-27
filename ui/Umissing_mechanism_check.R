tabPanel("MCAR test", fluid = TRUE,
         fluidRow(
           h2("MCAR test"),
           h5("Time needed for this test?"),
           p("The MCAR test may take miniutes to days depending on the size and complexity of your data. If your dataset is large (>5000 features and >100 samples), it may take day to finish."),
           h5("When do I need to perform this test?"),
           p("we belive that it's meaningless to perform MCAR test before processing the low abundance induced missing. Because with the existence of the low abundance induced missing, the missing mechanism could be MNAR."),
           actionButton("mcartest", "Click to perform the MCAR test!"),
           textOutput("MCARtest"),
           hr(),
           h2("Missing data percent after imputation of low intensity induced missing value"),
           p("The following two figures show the percent of the remaining missing value, and the proportion of the affected features"),
           column(6,
                  plotOutput("mzmisspercentfilter")
           ),
           column(6,
                  plotOutput("totalmisspercentfilter")
           ),
           #h2("Missing distribution after imputation of low intensity induced missing value"),
           #p(""),
           #column(6,
           p("The following figure shows the distribution of remaining missing value"),
                  plotOutput("missmatrix_low_fliter")
          # ),
          # column(6,
          #        plotOutput("samplepercentfilter")
          # )
           
           
           
         )
)