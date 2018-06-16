tabPanel("Tutorial", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
                   fluidRow(
                     h2("What's SIM?"),
                     h5("SIM"),
                     p("SIM is short for Smart Imputation of untargeted Metabolomics data sets. 
                       It's a shiny application designed to handling missing data in a systematic way"),
                     h5("The advantage of SIM"),
                     p("1. It's could keep the biological interesting features by using group based missing data filtering and by imputing the total group missing and LOQ induced missing with minimum value"),
                     p("2. It provides evidence based visual evaluation the imputation effects"),
                     h5("How to use SIM?"),
                     p("The usage of SIM is very simple. Users need to provide a peak file and sample list file and follow the instructions"),
                     hr(),
                     h2("Missing data"),
                     h5("Origin of missing data"),
                     h5("Impact of missing data on downstream analysis"),
                     h2("Missing Mechanism"),
                     h5("MCAR"),
                     h5("MAR"),
                     h5("MNAR"),
                     hr(),
                     h2("Missing data imputation"),
                     h5("classification of missing imputation"),
                     h5("global structure based imputation"),
                     h5("local structure based imputation"),
                     h5("mechanism learning based imputation"),
                     h5("multi-imputation"),
                     hr(),
                     h2("Evaluation of imputation effects"),
                     h5("RMSE"),
                     h5("classification"),
                     h5("other"),
                     hr(),
                     h2("missing value handling consideration")
                     
                   )
         )
)
