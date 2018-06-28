tabPanel("Imputation Evaluation", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
                   fluidRow(
                     h2("Usage"),
                     p("The imputation results are compared in the following ways:"),
                      p("(1) Supervised and unsupervised classification accuarcy. PCA and culstering analysis are used for unsupervised classification. pcalda is used for supervised classification. "), 
                      p("(2) The impact of imputation on the differential analysis. if the calssification accuarcy are similar between two imputation results, it may be because the two imputation has similar effects or becuase the classification is not sigificantly affected by the missing value imputation.  
                       the impact of imputation on differential analysis measures the difference of imputation results on the feature level, thus it's more sensitive."),
                     hr(),
                     h2("Choose two methods for comparison"),
                     p("If your data is MCAR and you only perform one imputation, please skip this step."),
                     p("If you have performed more than one imputation, please select two imputation results to compare them."),
                     p("You can only compare two imputation each time."),
                     selectizeInput(# Replace with what you want to have in sidebarPanel
                       'inputId' = "impmethodsel"
                       , 'label' = "Please select two imputation methods:"
                       , 'choices' = c("kNN","bpca","missforest","ppca","svd","lls")
                       , 'selected' = ""  # pick first column in dataset as names
                       , multiple = TRUE
                       , options = list(maxItems = 2)
                     ),
                     hr(),
                     h2("Comparision based on unsupervised classification accuarcy"),
                     h4("Results of PCA analysis"),
                     h5("PCA results of the original data and the imputed data"),
                     column(4,
                            
                            plotOutput("originPCA")
                     ),
                     column(4,
                            plotOutput("imp1PCA")
                     ),
                     column(4,
                            plotOutput("imp2PCA")
                     ),
                     h4("Results of clustering analysis"),
                     column(6,
                            plotOutput("imp1cluster")
                     ),
                     column(6,
                            plotOutput("imp2cluster")
                     ),
                     hr(),
                     h2("Comparision based on supervised classification accuarcy"),
                     textOutput("imp1accuracy"),
                     textOutput("imp2accuracy"),
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