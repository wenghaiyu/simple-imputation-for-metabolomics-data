tabPanel("Filtering", fluid = TRUE,
         fluidPage(theme = shinytheme("cerulean"),
         fluidRow(
           h2("Usage:"),
           p("In this step, we will remove the features containing large porportion of missing value.
              Two kinds of methods are avaibale: group based filtering and traditional filtering."),
           h2("group based filtering"),
           p("Please set the minimum missing ratio for the QC and study samples. 
              Features from QC sampples that have a higher missing ratio than the threshould will be removed.
              Features from study sample that have a higher missing ratio in all biological groups than the threshould will be removed.
              To help you to set the threshould, we have plot the missing ratio distribution in qc and each biological group."),
           plotOutput("missbygroup"),
           column(6,
                  sliderInput("qcpercents", "Percent of missing in QC sample",
                              min = 0, max = 1, value = 0.5
                  )
                  ),
           column(6,
                  sliderInput("samplepercents", "Percent of missing in study sample",
                              min = 0, max = 1, value = 0.5
                  )
                  ),
           textOutput("removednog"),
           
           hr(),
           h2("traditional filtering"),
           p("Please set the minimum missing ratio for the QC and study samples. 
              Features from QC sampples that have a higher missing ratio than the threshould will be removed.
              Features from all study sample that have a higher missing ratio than the threshould will be removed.
              To help you to set the threshould, we have plot the missing ratio distribution in qc and study samples."),
           plotOutput("misstraditional"),
           column(6,
                  sliderInput("qcpercentst", "Percent of missing in QC sample",
                              min = 0, max = 1, value = 0.5
                  )
           ),
           column(6,
                  sliderInput("samplepercentst", "Percent of missing in study sample",
                              min = 0, max = 1, value = 0.5
                  )
           ),
           textOutput("removednot"),
           hr(),
           h2("Difference between the two filtering strategies:"),
           p("Overlap of the two filtering results, you can check the different filtered features to figure out which method is more realiable"),
           column(4,
                  h4("difference between the two filtering strategies:"),
                  plotOutput("venndiff")
           ),
           column(4,
                  h4("features that are removed by traditional method but kept by group based method"),
                  plotOutput("ingroup_out_traditional")
           ),
           column(4,
                  h4("features that are removed by group based method but kept by traditional method"),
                  plotOutput("intradition_out_group")
                  ),
           hr(),
           h2("Plesse select which data filtering result you want to use:"),
           radioButtons("filtersel", "Select a filtering result:",
                        c("group_based_filtering_result" = "group_based_filtering_result",
                          "traditional_filtering_result" = "traditional_filtering_result",
                          "do_no_filtering" = "do_not_filtering"))
           
         )
         #tableOutput("datafilter")
         )
)





