tabPanel("Imputation", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
                   fluidRow(
                     h2("Usage"),
                     p("Click the following buttons to perform imputation:"),
                     p("The imputation could not be applied to your data unless you click the action botton. The imputation result could be downloaded after the imputation finished."),
                     p("The imputation would take a long time to complete, which depends on the amount of your data, please wait. and do not clikc one button many times"),
                     hr(),
                     h2("Choose imputation methods"),
                     h4("Local structure based imputation:"),
                     p("The local structure based imputation replace the missing value based on the expression profiles of several other features with similar intensity profiles in the same dataset."),
                     p("This strategy ,in general, make the assumption that the features are regulated dependently.and the highly correlated profiles are observed with coregulated features"),
                     p("K nearest neighbors (KNN) and local least-squares (LLS) are two most often used methods:"),
                     column(6,
                            actionButton("knn", "Click to perform kNN imputation!"),
                            p(),
                            #p(),
                            downloadLink("downloadknnData", "Download kNN imputed data")
                     ),
                     column(6,
                            actionButton("lls", "Click to perform lls imputation!"),
                            p(),
                            #p(),
                            downloadLink("downloadllsData", "Download lls imputed data")
                     ),
                     p("."),
                     hr(),
                     h4("Global structure based imputation:"),
                     p("The local structure based imputation replace the missing value based on the expression profiles of several other features with similar intensity profiles in the same dataset."),
                     p("This strategy ,in general, make the assumption that the features are regulated dependently.and the highly correlated profiles are observed with coregulated features"),
                     p("K nearest neighbors (KNN) and local least-squares (LLS) are two most often used methods:"),
                     column(4,
                            actionButton("bpca", "Click to perform bpca imputation!"),
                            p(),
                           # p("tolerant to relatively high amount of missing data (>10%)"),
                            downloadLink("downloadbpcaData", "Download bpca imputed data")
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
                     p("."),
                     hr(),
                     h4("machine learning based imputation:"),
                     p("The local structure based imputation replace the missing value based on the expression profiles of several other features with similar intensity profiles in the same dataset."),
                     p("This strategy ,in general, make the assumption that the features are regulated dependently.and the highly correlated profiles are observed with coregulated features"),
                     p("K nearest neighbors (KNN) and local least-squares (LLS) are two most often used methods:"),
                     actionButton("missforest", "Click to perform missforest imputation!"),
                     p(),
                     downloadLink("downloadmfData", "Download missforest imputed data"),
                     hr(),
                     h2("Reliability of the imputation"),
                     p("The reliablity of the imputation results is shown in the following figures. 
                       the left figure shows the distribution of all the imputed data and the observed data.The total imputed data is expected to has similar mean and standard deviation with the observed data.
                       the middle and right figure show the imputed and observed data on sample and feature level. You can find out if there exists outliers"),
                     conditionalPanel(
                       condition = "input.knn == 1",
                       hr(),
                       h4("Results of kNN imputation"),
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
                       hr(),
                       h4("Results of bpca imputation"),
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
                       h4("Results of missforest imputation"),
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
                      hr(),
                      h4("Results of ppca imputation"),
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
                      hr(),
                      h4("Results of svd imputation"),
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