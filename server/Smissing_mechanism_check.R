
output$mzmisspercentfilter <- renderPlot({
  data <- minimunImputed()
  mz_miss <- table(sapply(data[,-c(1,2,3,4,5)], function(x){any(is.na(x))})) %>%
    as.data.frame() %>%
    merge(value$a,by.x="Var1",by.y="value")
  pie(mz_miss$Freq,mz_miss$group,main = "mz contain missing", col = rainbow(length(mz_miss$Freq)))
})

output$totalmisspercentfilter <- renderPlot({
  data <- minimunImputed()
  miss_compose <- data.frame(
    group = c("no_miss","has_miss"),
    Freq = c(sum(!(is.na(data[,-c(1,2,3,4,5)]))),sum(is.na(data[,-c(1,2,3,4,5)])))
  )
  pie(miss_compose$Freq,miss_compose$group,main = "total missing data percent", col = rainbow(length(miss_compose$Freq)))
})

output$mzmissintensityfilter <- renderPlot({
  data <- minimunImputed()
  mean_intensity <- apply(data[,-c(1,2,3,4,5)],2,function(x){mean(as.numeric(x),na.rm = T)})  #head(mean_intensity)
  miss_ratio <- apply(data[,-c(1,2,3,4,5)],2,function(x){sum(is.na(x))/length(x)})  #head(miss_ratio)
  intensity_miss_ratio <- data.frame(mean_intensity,miss_ratio) #head(intensity_miss_ratio)
  ggplot(subset(intensity_miss_ratio,miss_ratio>0),aes(mean_intensity,miss_ratio))+geom_point()
})

output$samplepercentfilter <- renderPlot({
  data <- minimunImputed()
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

mcarresult <- eventReactive(input$mcartest, {
  data <- minimunImputed()
  data1 <- t(as.matrix(data[,-c(1:5)]))
  outs <- TestMCARNormality(data = data1)
  print(outs)
  outs
  return(outs)
})

output$MCARtest <- renderText({
  mcarresult()
})