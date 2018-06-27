
options(shiny.maxRequestSize=30*1024^2)

peakData <- reactive({
  validate(
    need(input$peakfile != "", "Please upload peak file")
  )
  inFile1 <- input$peakfile
  if (is.null(inFile1))
    return(NULL)
  read_csv(inFile1$datapath,n_max = 500)
})

listData<- reactive({
  validate(
    need(input$listfile != "", "Please upload list file")
  )
  inFile2 <- input$listfile
  if (is.null(inFile2))
    return(NULL)
  read.delim(inFile2$datapath,header = T,sep="\t")
})

mergedf <- reactive({
  peak <- peakData()
  list <- listData()
  list$mark <- "sample"
  list$mark[list$class=="QC"] <- "QC"
  peak[peak==0] <- NA
  peakt <- as.data.frame(t(peak[,-c(1,2)]))
  names(peakt) <- peak$mz
  peakt$sample <- row.names(peakt)
  inner_join(list,peakt,by="sample")
})

value <- reactiveValues() # rv <- reactiveValues(value = 0)
value$a=data.frame(
  group = c("no_miss","has_miss"),
  value = c("FALSE", "TRUE")
)

#output$samplemisspercent <- renderPlot({
#  data <- mergedf()
#  sample_miss <- table(apply(data[,-c(1,2,3,4,5)],1,function(x){any(is.na(x))})) %>%
#    as.data.frame() %>%
#    merge(value$a,by.x="Var1",by.y="value")
#  pie(sample_miss$Freq,sample_miss$group,main = "sample contain missing", col = rainbow(length(sample_miss$Freq)))
  
#})

output$mzmisspercent <- renderPlot({
  data <- mergedf()
  mz_miss <- table(sapply(data[,-c(1,2,3,4,5)], function(x){any(is.na(x))})) %>%
    as.data.frame() %>%
    merge(value$a,by.x="Var1",by.y="value")
  pie(mz_miss$Freq,mz_miss$group,main = "mz contain missing", col = rainbow(length(mz_miss$Freq)))
})

output$totalmisspercent <- renderPlot({
  data <- mergedf()
  miss_compose <- data.frame(
    group = c("no_miss","has_miss"),
    Freq = c(sum(!(is.na(data[,-c(1,2,3,4,5)]))),sum(is.na(data[,-c(1,2,3,4,5)])))
  )
  pie(miss_compose$Freq,miss_compose$group,main = "total missing data percent", col = rainbow(length(miss_compose$Freq)))
})

output$samplepercent <- renderPlot({
  data <- mergedf()
  list <- listData()
  sample_name <- data$sample
  data <- as.data.frame(t(data[,-c(1,2,3,4,5)]))
  names(data) <- sample_name
  md_pattern <- md.pattern(data)
  #missing percent in each sample boxplot
  sample_miss_number <- md_pattern[nrow(md_pattern),][-ncol(md_pattern)]/nrow(data)
  sample_miss_number_plot <- data.frame(
    sample=names(sample_miss_number),
    percents=sample_miss_number
  ) 
    inner_join(list[,c(1,3)],sample_miss_number_plot,by="sample") %>%
    ggplot(aes(class,percents))+
    geom_boxplot()+
    geom_jitter(width = 0.2)
})

output$missmatrix <- renderPlot({
  data <- mergedf()
  list <- listData()
  sample_name <- data$sample
  data <- as.data.frame(t(data[,-c(1,2,3,4,5)]))
  names(data) <- sample_name
  annotation_col = as.data.frame(list[,3,drop=F])
  row.names(annotation_col) <- list$sample
  sorted_name <- row.names(annotation_col[order(annotation_col$class),1,drop=F])
  mz_sel <- which(apply(data,1,function(x){any(is.na(x))})=="TRUE")
  sorted_order_matrixplot <- sapply(sorted_name,function(x){which(colnames(data)==x)})
  #print(sorted_name)
  #print(mz_sel)
  #print(sorted_order_matrixplot)
  matrixplot(data[mz_sel,sorted_order_matrixplot], interactive = F)
})

output$misspattern <- renderPlot({
  data <- mergedf()
  list <- listData()
  sample_name <- data$sample
  data <- as.data.frame(t(data[,-c(1,2,3,4,5)]))
  names(data) <- sample_name
  md_pattern <- md.pattern(data)
  if(length(row.names(md_pattern))>50){
    the_50th_number <- sort(as.numeric(row.names(md_pattern)),decreasing = T)[50]
  }else{
    the_50th_number <- 0
  }
  sel <- which(as.numeric(row.names(md_pattern))>the_50th_number)# get the 20 th largest number
  plot_d <- md_pattern[sel,-ncol(md_pattern)] # choose pattern
  annotation_col = as.data.frame(list[,3,drop=F])
  row.names(annotation_col) <- list$sample
  sorted_name <- row.names(annotation_col[order(annotation_col$class),1,drop=F])
  sorted_order <- sapply(sorted_name,function(x){which(colnames(plot_d)==x)})
  plot_d <- plot_d[,sorted_order]
  pheatmap(plot_d, annotation_col = annotation_col,cluster_cols = FALSE,legend = FALSE)
})

output$mzmissintensity <- renderPlot({
  data <- mergedf()
  mean_intensity <- apply(data[,-c(1,2,3,4,5)],2,function(x){mean(as.numeric(x),na.rm = T)})  #head(mean_intensity)
  miss_ratio <- apply(data[,-c(1,2,3,4,5)],2,function(x){sum(is.na(x))/length(x)})  #head(miss_ratio)
  intensity_miss_ratio <- data.frame(mean_intensity,miss_ratio) #head(intensity_miss_ratio)
  ggplot(subset(intensity_miss_ratio,miss_ratio>0),aes(mean_intensity,miss_ratio))+geom_point()
})

output$mzmissmz <- renderPlot({
  data <- mergedf()
  mean_intensity <- apply(data[,-c(1,2,3,4,5)],2,function(x){mean(as.numeric(x),na.rm = T)})  #head(mean_intensity)
  miss_ratio <- apply(data[,-c(1,2,3,4,5)],2,function(x){sum(is.na(x))/length(x)})  #head(miss_ratio)
  intensity_miss_ratio <- data.frame(mean_intensity,miss_ratio) #head(intensity_miss_ratio)
  intensity_miss_ratio$mz <- as.numeric(row.names(intensity_miss_ratio))
  ggplot(subset(intensity_miss_ratio,miss_ratio>0),aes(mz,miss_ratio))+geom_point()
})

output$mzmissrt <- renderPlot({
  data <- mergedf()
  peak <- peakData()
  mean_intensity <- apply(data[,-c(1,2,3,4,5)],2,function(x){mean(as.numeric(x),na.rm = T)})  #head(mean_intensity)
  miss_ratio <- apply(data[,-c(1,2,3,4,5)],2,function(x){sum(is.na(x))/length(x)})  #head(miss_ratio)
  intensity_miss_ratio <- data.frame(mean_intensity,miss_ratio) #head(intensity_miss_ratio)
  intensity_miss_ratio$mz <- as.numeric(row.names(intensity_miss_ratio))
  rt_intensity <- merge(intensity_miss_ratio,peak[,c(1,2)],by.x="mz",by.y="mz")
  rt_intensity$RT <- as.numeric(as.character(rt_intensity$RT))
  ggplot(subset(rt_intensity,miss_ratio>0),aes(RT,miss_ratio))+geom_point()
})


output$outlier <- renderPlot({
  data1 <- mergedf()
  data <- as.matrix(data1[,-c(1,2,3,4,5)])
  sgroup <- data1[,3]
  rownames(data) <- data1$sample
  pc <- pca(data, nPcs=2, method="ppca")
  slplot(pc, sl=NULL, spch=5)
  plotd <- cbind(sgroup,as.data.frame(pc@scores))
  ggplot(plotd,aes(PC1,PC2))+
    geom_point(aes(colour=sgroup))+
    stat_ellipse(aes(x=PC1, y=PC2,color=sgroup),type = "norm")
})

#output$samplecorrelation <- renderPlot({
#  data <- mergedf()
#  list <- listData()
#  x <- as.data.frame(abs(is.na(data[,-c(1,2,3,4,5)])))
#  #sample correlation
#  sx <- as.data.frame(t(x))
#  names(sx) <- data$sample
#  sy <- sx[,sapply(sx, sd) > 0]
#  cor_sy <- cor(sy)
#  annotation_col = as.data.frame(list[,3,drop=F])
#  row.names(annotation_col) <- list$sample
#  pheatmap(cor_sy,show_colnames = F,show_rownames = F,annotation_col = annotation_col)
#})

