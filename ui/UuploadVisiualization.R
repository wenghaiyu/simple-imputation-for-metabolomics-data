tabPanel("Upload and Visiualization", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
           fluidRow(
             h2("File upload"),
             p("Uplaod your data or try our example data at https://github.com/zhanlongmei/simple-imputation-for-metabolomics-data"),
             p("Have no idea how to prepare your data? please refer to our tutorial panel"),
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
                    h2("Visualization of the missing pattern:"),
                    p("Data visiualization would give you answers to the following question:"),
                    p("1.how much missing data you have is it low or high?"),
                    p("2.the missing data distribution pattern,do they have some regular patterns?"),
                    p("3.Is missing value associated with intensity, mz value or RT?"),
                    p("4.Do you have outlier samples?"),
                    hr(),
                    h3("Miss percent"),
                    p("This two figures represent the percent of missing and the proportion of features containing missing value.
                      If your missing data composes less than 5% of the total datasets.
                      It means that you have a relative low missing ratio 
                      and these missing value may not introduce significant bias during statistical analysis."),
                    column(6,
                      plotOutput("mzmisspercent")
                    ),
                    column(6,
                      plotOutput("totalmisspercent")
                    ),
                    hr(),
                    h3("missing value distribution"),
                    p("The left figure shows the distribution of missing value on the whole data set: each row represents a feature,each column represents a sample."),
                    p("The right figure shows the most frequent patterns: each row represents a feature,each column represents a sample. The frequence is labeled on the right"),
                    column(6,
                           plotOutput("missmatrix")
                    ),
                    column(6,
                           plotOutput("misspattern")
                    ),
                    hr(),
                    h3("systematic error inspection"),
                    p("These three figures show the relation of the missing ratio with the mean mz intensity, mz value and the retention time."),
                    p("Most of the missing value is caused by low abundance, so the low intensity features could contain more missing data."),
                    p("If spectific range of mz value or retention time contain much more missing value. One have to make sure is it caused by systematic error or not."),
                    column(4,
                           plotOutput("mzmissintensity")
                    ),
                    column(4,
                           plotOutput("mzmissmz")
                    ),
                    column(4,
                           plotOutput("mzmissrt")
                    ),
                    hr(),
                    h3("outlier analysis"),
                    p("The outliers would have a dramatic effect on the imputation results. It's necessary to findout the outlier samples before imputation"),
                    p("The PCA plot (left) and the missing ratio in each sample (right) are used for this purpose."),
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
