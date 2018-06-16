tabPanel("Imputation Evaluation", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
                   fluidRow(
                     h2("Usage"),
                     p("In this step, you can compare the imputation methodsin the following way: 
                       (1) we will check the difference of the differential expressed features, if there is no big difference, then we assume this two imputation has similar effects, 
                       if there is a big difference, we could (2) compare the classification accuracy 
                       and (3) check the different significant features and figure why they are different"),
                     h2("Comparision based on classification accuarcy"),
                     h4("Choose two methods for comparison"),
                     column(6,
                            selectizeInput(# Replace with what you want to have in sidebarPanel
                              'inputId' = "impmethodsel"
                              , 'label' = "Please select two imputation methods:"
                              , 'choices' = c("kNN","bpca","missforest")
                              , 'selected' = ""  # pick first column in dataset as names
                              , multiple = TRUE
                              , options = list(maxItems = 2)
                            )
                     ),
                     column(6,
                            p("If your data is MCAR and you only perform one imputation, please skip this step."),
                            p("If you have performed more than one imputation, please select two imputation results to compare them."),
                            p("You can only compare two imputation each time.")
                     ),
                     h4("Results of PCA and classification accuracy"),
                     h5("PCA results of the original data and the imputed data"),
                     column(4,
                            
                            plotOutput("originPCA")
                     ),
                     column(4,
                            plotOutput("imp1PCA"),
                            textOutput("imp1accuracy")
                     ),
                     column(4,
                            plotOutput("imp2PCA"),
                            textOutput("imp2accuracy")
                     ),
                     p(),
                     h2("Comparision based on differential expressed features"),
                     h4("please select two biological groups"),
                     column(6,
                            uiOutput("selgroup")
                            ),
                     column(6,
                            plotOutput("venndiffmz")
                            ),
                     h4("where the difference origin"),
                     plotOutput("in1out2"),
                     plotOutput("in2out1")
                   )
         )
)