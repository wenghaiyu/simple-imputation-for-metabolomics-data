tabPanel("MCAR test", fluid = TRUE,
         fluidRow(
           h2("Missing data percent after imputation of low intensity induced missing value"),
           column(6,
                  plotOutput("mzmisspercentfilter")
           ),
           column(6,
                  plotOutput("totalmisspercentfilter")
           ),
           h2("Missing distribution after imputation of low intensity induced missing value"),
           column(6,
                  plotOutput("mzmissintensityfilter")
           ),
           column(6,
                  plotOutput("samplepercentfilter")
           ),
           hr(),
           actionButton("mcartest", "Click to perform the MCAR test!"),
           textOutput("MCARtest")
           
         )
)