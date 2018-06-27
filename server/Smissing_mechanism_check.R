
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

output$missmatrix_low_fliter <- renderPlot({
  data <- minimunImputed()
  list <- listData()
  sample_name <- data$sample
  data <- as.data.frame(t(data[,-c(1,2,3,4,5)]))
  names(data) <- sample_name
  annotation_col = as.data.frame(list[,3,drop=F])
  row.names(annotation_col) <- list$sample
  sorted_name <- row.names(annotation_col[order(annotation_col$class),1,drop=F])
  mz_sel <- which(apply(data,1,function(x){any(is.na(x))})=="TRUE")
  sorted_order_matrixplot <- sapply(sorted_name,function(x){which(colnames(data)==x)})
  matrixplot(data[mz_sel,sorted_order_matrixplot], interactive = F)
})

mcarresult <- eventReactive(input$mcartest, {
  data <- minimunImputed()
  data1 <- t(as.matrix(data[,-c(1:5)]))
  colnames(data1) <- data$sample
  s <- LittleMCAR(data1)
  print(s$amount.missing)
  return(s$p.value)
})

output$MCARtest <- renderText({
  paste("The p value of the MCAR test is: ",mcarresult(),sep="")
})