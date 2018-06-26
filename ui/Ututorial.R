tabPanel("Tutorial", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
                   fluidRow(
                     h2("What's SIM?"),
                     h5("SIM"),
                     p("SIM is short for Simple Imputation of untargeted Metabolomics data sets. 
                       It's a shiny application designed to handling missing data in a systematic way"),
                     h5("The advantage of SIM"),
                     p("1. It's could keep the biological interesting features by using group based missing data filtering and imputing the total group missing and LOQ induced missing with minimum value"),
                     p("2. It provides evidence based visual evaluation the imputation effects"),
                     hr(),
                     h2("How to use SIM?"),
                     p("The usage of SIM is very simple. Users need to provide a peak file and sample list file and follow the instructions"),
                     hr(),
                     h2("Source code and example data"),
                     p("The source code and example data can be found on https://github.com/zhanlongmei/simple-imputation-for-metabolomics-data"),
                     hr(),
                     h2("How does the SIM work?"),
                     tags$img(src = "SIM_pipeline.png", width = "500px", height = "500px"),
                     p("Once the peak table and sample list file are uploaded, a comprehensive visualization of the missing pattern is shown."),
                     p("The first step is to remove the severe missing, and two filtering strategies are provided"),
                     p("The second step is to process the total group missing and the low abundance induced missing"),
                     p("After these processing, the missing mechanism is checked using Little's test"),
                     p("Six imputation methods are provided to choose and an interactive evaluation is avaiable"),
                     hr(),
                     h2("How to prepare my data"),
                     h5("Sample list"),
                     p("The sample list is a txt file containing the sample information, it should contain four colums: \"sample	batch	class	order\". "),
                     p("sample refers to sample name; batch refers to the batch information; class refers to the biological group, the QC group must be named as \"QC\", as shown in our example data; order refers to the injetion order."),
                     h5("Peak table"),
                     p("The peak table is a csv file containing the peak intensity, the first columns must be mz and RT, the rest columns are sample names. Each row represents a mz"),
                     p("The sample names in the peak table must be the same with sample names in the sample list file.")
                     
                   )
         )
)
