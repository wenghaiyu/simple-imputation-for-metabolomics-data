groupfilterdata <- reactive({
  data <- mergedf()
  qc_ratio <- input$qcpercents
  sam_ratio <- input$samplepercents
  miss_ratio_by_class <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$class),ratio_count)   #miss_ratio_by_class[,c(1:5)]
  qc_miss_ratio <- as.data.frame(t(miss_ratio_by_class[miss_ratio_by_class$Group.1=="QC",-1]) >= qc_ratio)    #head(qc_miss_ratio)
  names(qc_miss_ratio) <- c("qc")
  qc_fliter_mz <- row.names(subset(qc_miss_ratio,qc=="TRUE"))
  
  sam_miss_ratio <- miss_ratio_by_class[!(miss_ratio_by_class$Group.1=="QC"),]  #sam_miss_ratio[,c(1:5)]
  sam_miss_judge <- apply(sam_miss_ratio[,-1],2,function(x){all(x>=sam_ratio)})
  sample_fliter_mz <- names(which(sam_miss_judge=="TRUE"))
  
  mz_fliter <- union(qc_fliter_mz,sample_fliter_mz)   #length(mz_fliter)
  data_flitered <- data[,!(names(data) %in% mz_fliter)] 
  return(data_flitered)
})

traditionaldata <- reactive({
  data <- mergedf()
  qc_ratio <- input$qcpercentst
  sam_ratio <- input$samplepercentst
  miss_ratio_by_type <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$mark),ratio_count)   #miss_ratio_by_type[,c(1:10)]
  miss_ratio_by_type2 <- as.data.frame(t(miss_ratio_by_type[,-1]))
  names(miss_ratio_by_type2) <- miss_ratio_by_type$Group.1             #head(miss_ratio_by_type2)
  mz_filter <- row.names(subset(miss_ratio_by_type2,QC >= qc_ratio | sample >= sam_ratio))   #length(mz_filter)
  data_flitered <- data[,!(names(data) %in% mz_filter)]
  return(data_flitered)
})


output$missbygroup <- renderPlot({
  data <- mergedf()
  miss_ratio_by_class <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$class),ratio_count)
  miss_ratio_by_class2 <- as.data.frame(t(miss_ratio_by_class[,-1]))
  names(miss_ratio_by_class2) <- miss_ratio_by_class$Group.1
  cmdd <- paste("gather(miss_ratio_by_class2,`",
                paste(names(miss_ratio_by_class2),collapse = "`,`"),
                "`,key='type',value='missratio')",
                sep="")
  
  eval(parse(text=cmdd)) %>%
    filter(missratio>0) %>%
    ggplot(aes(missratio,fill=type))+geom_histogram(binwidth = 0.1)+facet_grid(. ~ type)
  
})

output$misstraditional <- renderPlot({
  data <- mergedf()
  miss_ratio_by_type <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$mark),ratio_count)   #miss_ratio_by_type[,c(1:10)]
  miss_ratio_by_type2 <- as.data.frame(t(miss_ratio_by_type[,-1]))
  names(miss_ratio_by_type2) <- miss_ratio_by_type$Group.1   
  miss_ratio_by_type2 %>%
    gather(`QC`,`sample`,key="type",value="missratio") %>%
    filter(missratio>0) %>%
    ggplot(aes(missratio))+geom_histogram(binwidth = 0.1)+facet_grid(. ~ type)
})

output$venndiff <- renderPlot({
  g_left_mz <- names(groupfilterdata())[-c(1:5)]
  t_left_mz <- names(traditionaldata())[-c(1:5)]
  intergt <- intersect(g_left_mz,t_left_mz)
  gl <- length(g_left_mz)
  tl <- length(t_left_mz)
  gt <- length(intergt)
  draw.pairwise.venn(
    area1 = gl,
    area2 = tl,
    cross.area = gt,
    category = c("G", "T"),
    fill = c("blue", "red"),
    lty = "blank",
    cex = 2,
    cat.cex = 2,
    cat.pos = c(285, 105),
    cat.dist = 0.09,
    cat.just = list(c(-1, -1), c(1, 1)),
    ext.pos = 30,
    ext.dist = -0.05,
    ext.length = 0.85,
    ext.line.lwd = 2,
    ext.line.lty = "dashed"
  )
})


output$ingroup_out_traditional <- renderPlot({
  list <- listData()
  #list <- list[(list$class != "QC"),]
  list <- list[order(list$class),]
  group_filtered_data <- groupfilterdata()    #group_filtered_data[c(1:5),c(1:10)]
  traditional_filtered_data <- traditionaldata()     #traditional_filtered_data[c(1:5),c(1:10)]
  original <- mergedf()
  
  group_filter_left_mz <- setdiff(names(group_filtered_data),names(traditional_filtered_data))  #original[c(1:5),c(1:10)]

  validate(
    need(group_filter_left_mz >0, "no feature")
  )
  group_filter_left <- original[,c(3,which(names(original) %in% group_filter_left_mz))]  #group_filter_left[c(1:5),]
  group_filter_left2 <- t(group_filter_left[,-1])   #group_filter_left2[,c(1:5)]

  colnames(group_filter_left2) <- original$sample
  #orderclass <- sort(group_filter_left$class)
  sorted_order_matrixplot <- sapply(list$sample,function(x){which(colnames(group_filter_left2)==x)})
  matrixp <- group_filter_left2[,sorted_order_matrixplot]
  colnames(matrixp) <- list$class
  matrixplot(matrixp)
})

output$intradition_out_group <- renderPlot({
  list <- listData()
  #list <- list[(list$class != "QC"),]
  list <- list[order(list$class),]
  group_filtered_data <- groupfilterdata()    #group_filtered_data[c(1:5),c(1:10)]
  traditional_filtered_data <- traditionaldata()     #traditional_filtered_data[c(1:5),c(1:10)]
  original <- mergedf()
  group_filter_left_mz <- setdiff(names(traditional_filtered_data),names(group_filtered_data))  #original[c(1:5),c(1:10)]
  validate(
    need(group_filter_left_mz >0, "no feature")
  )
  group_filter_left <- original[,c(3,which(names(original) %in% group_filter_left_mz))]  #group_filter_left[c(1:5),]
  group_filter_left2 <- t(group_filter_left[,-1])   #group_filter_left2[,c(1:5)]
  colnames(group_filter_left2) <- original$sample
  #orderclass <- sort(group_filter_left$class)
  sorted_order_matrixplot <- sapply(list$sample,function(x){which(colnames(group_filter_left2)==x)})
  matrixp <- group_filter_left2[,sorted_order_matrixplot]
  colnames(matrixp) <- list$class
  matrixplot(matrixp)
})

output$removednog <- renderText({
  data1 <- mergedf()
  #observeEvent(input$do, {
  data2 <- groupfilterdata()
  filteredno <- ncol(data1)-ncol(data2)
  paste("A total of ",filteredno,"peaks have been filtered!") 
  #})
})

output$removednot <- renderText({
  data1 <- mergedf()
  #observeEvent(input$do, {
  data2 <- traditionaldata()
  filteredno <- ncol(data1)-ncol(data2)
  paste("A total of ",filteredno,"peaks have been filtered!") 
  #})
})

datafiltered <- reactive({
  #print(input$filtersel)
  if(input$filtersel == "group_based_filtering_result"){
    return(groupfilterdata())
    #print(input$filtersel)
  }else if(input$filtersel == "traditional_filtering_result"){
    return(traditionaldata())
   # print(input$filtersel)
  }else{
    return(mergedf())
  }
})

#output$datafilter <- renderTable(datafiltered()[c(1:5),c(1:5)])