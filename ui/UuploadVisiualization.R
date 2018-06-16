tabPanel("Upload and Visiualization", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
           fluidRow(
             h2("File upload"),
             column(6,
                    fileInput("peakfile", "Choose peak intensity File",
                              accept = c(
                                "text/csv",
                                "text/comma-separated-values,text/plain",
                                ".csv")
                    )
             ),
             column(6,
                    fileInput("listfile", "Choose sample information File",
                              accept = c(
                                "text/txt",
                                "text/comma-separated-values,text/plain",
                                ".txt")
                    )
             )
           ),
           hr(),
             fluidRow(
                    h2("Data visiualization results:"),
                    p("Data visiualization would give you answers to the following question:"),
                    p("1.how much missing data you have is it low or high?"),
                    p("2.the missing data distribution pattern,do they have some regular patterns?"),
                    p("3.Is missing value associated with intensity, mz value or RT?"),
                    p("4.Do you have outlier samples?"),
                    h3("Miss percent"),
                    p("This two figures represents the percent of missing.
                      If your missing data composes less than 5% of the total datasets.
                      It means that you have a relative low missing ratio"),
                    column(6,
                      plotOutput("mzmisspercent")
                    ),
                    column(6,
                      plotOutput("totalmisspercent")
                    ),
                    h3("sample perspective"),
                    column(6,
                           plotOutput("missmatrix")
                    ),
                    column(6,
                           plotOutput("misspattern")
                    ),
                    h3("missing ratio dependence"),
                    column(4,
                           plotOutput("mzmissintensity")
                    ),
                    column(4,
                           plotOutput("mzmissmz")
                    ),
                    column(4,
                           plotOutput("mzmissrt")
                    ),
                    
                    h3("outlier analysis"),
                    p("The outliers would have a dramatic effect on the imputation results. It's necessary to findout the outlier samples before perform imputation"),
                    column(6,
                           plotOutput("outlier")
                    ),
                    column(6,
                           plotOutput("samplepercent")
                    )
                    
                    #plotOutput("outlier"),
                    #plotOutput("samplepercent"),
                    #plotOutput("samplecorrelation")
             )
           
           
         )
)
