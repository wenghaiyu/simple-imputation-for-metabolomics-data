tabPanel("Imputation", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
                   fluidRow(
                     h2("Usage"),
                     p("Click the following button to perform one or more imputed results:"),
                     p("each time you click one of the buttons, you would get one complete data. If you click two buttons, you would get two complete data"),
                     p("The imputation would take a long time to complete, which depends on the amount of your data, please wait. and do not clikc one button many times"),
                     h2("Choose imputation methods"),
                     column(4,
                            actionButton("knn", "Click to perform kNN imputation!"),
                            p(),
                            #p(),
                            downloadLink("downloadknnData", "Download kNN imputed data")
                     ),
                     column(4,
                            actionButton("bpca", "Click to perform bpca imputation!"),
                            p(),
                           # p("tolerant to relatively high amount of missing data (>10%)"),
                            downloadLink("downloadbpcaData", "Download bpca imputed data")
                     ),
                     column(4,
                            actionButton("missforest", "Click to perform missforest imputation!"),
                            p(),
                            downloadLink("downloadmfData", "Download missforest imputed data")
                     ),
                     column(4,
                            actionButton("ppca", "Click to perform ppca imputation!"),
                            p(),
                           # p("tolerant to amounts of missing values between 10% to 15%"),
                            downloadLink("downloadppcaData", "Download ppca imputed data")
                     ),
                     column(4,
                            actionButton("svd", "Click to perform svd imputation!"),
                            p(),
                           # p("tolerant to relatively high amount of missing data (>10%)"),
                            downloadLink("downloadsvdData", "Download svd imputed data")
                     ),
                     column(4,
                      #      actionButton("multi", "Click to perform multi imputation!"),
                            p("another imputation"),
                            plotOutput("xxx")
                        #    downloadLink("downloadmultiData", "Download multi_imputation imputed data")
                     ),
                     hr(),
                     conditionalPanel(
                       condition = "input.knn == 1",
                       h2("Results of kNN imputation"),
                       column(4,
                              plotOutput("knnvalidateall")
                              
                       ),
                       column(4,
                              plotOutput("knnvalidatemz")
                              ),
                       column(4,
                              plotOutput("knnvalidatesample")
                              )
                     ),
                     #conditionalPanel(
                    #   condition = "input.multi == 1",
                    #   h2("Results of multi imputation imputation"),
                    #   column(4,
                    #          plotOutput("multivalidateall")
                    #          
                    #   ),
                     #  column(4,
                    #          plotOutput("multivalidatemz")
                    #   ),
                    #   column(4,
                    #          plotOutput("multivalidatesample")
                    #   )
                    # ),
                     conditionalPanel(
                       condition = "input.bpca == 1",
                       h2("Results of bpca imputation"),
                       column(4,
                              plotOutput("bpcavalidateall")
                              
                       ),
                       column(4,
                              plotOutput("bpcavalidatemz")
                       ),
                       column(4,
                              plotOutput("bpcavalidatesample")
                       )
                     ),
                     conditionalPanel(
                       condition = "input.missforest == 1",
                       h2("Results of missforest imputation"),
                       column(4,
                              plotOutput("mfvalidateall")
                              
                       ),
                       column(4,
                              plotOutput("mfvalidatemz")
                       ),
                       column(4,
                              plotOutput("mfvalidatesample")
                       )
                     ),
                    conditionalPanel(
                      condition = "input.ppca == 1",
                      h2("Results of ppca imputation"),
                      column(4,
                             plotOutput("ppcavalidateall")
                             
                      ),
                      column(4,
                             plotOutput("ppcavalidatemz")
                      ),
                      column(4,
                             plotOutput("ppcavalidatesample")
                      )
                    ),
                    conditionalPanel(
                      condition = "input.svd == 1",
                      h2("Results of svd imputation"),
                      column(4,
                             plotOutput("svdvalidateall")
                             
                      ),
                      column(4,
                             plotOutput("svdvalidatemz")
                      ),
                      column(4,
                             plotOutput("svdvalidatesample")
                      )
                    )
                     
                   )
         )
)