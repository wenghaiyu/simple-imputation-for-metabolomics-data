knnimpute <- eventReactive(input$knn, {
  data <- minimunImputed()[,-c(1,2,3,4,5)]
  #all_value <- as.numeric(as.matrix(data))
  #low_value <- quantile(all_value,0.01,na.rm = T)
  data2 <- impute.knn(as.matrix(data))
  data3 <- data2$data
  data3[data3<0] <- 0.01
  data <- cbind(minimunImputed()[,c(1,2,3,4,5)],data3)
  return(data)
})

missforestimpute <- eventReactive(input$missforest, {
  data <- minimunImputed()[,-c(1,2,3,4,5)]
  #all_value <- as.numeric(as.matrix(data))
  #low_value <- quantile(all_value,0.01,na.rm = T)
  data2 <- missForest(data)$ximp
  data2[data2<0] <- 0.01
  data <- cbind(minimunImputed()[,c(1,2,3,4,5)],data2)
  return(data)
})

bpcaimpute <- eventReactive(input$bpca, {
  data <- minimunImputed()[,-c(1,2,3,4,5)]
  #all_value <- as.numeric(as.matrix(data))
  #low_value <- quantile(all_value,0.01,na.rm = T)
  row.names(data) <- minimunImputed()$sample
  data2 <- t(data)
  pc <- pca(data2,nPcs=2,method="bpca")
  imputed <- completeObs(pc)
  imputed[imputed<0] <- 0.01
  data <- cbind(minimunImputed()[,c(1,2,3,4,5)],as.data.frame(t(imputed)))
  return(data)
})

ppcaimpute <- eventReactive(input$ppca, {
  data <- minimunImputed()[,-c(1,2,3,4,5)]
  #all_value <- as.numeric(as.matrix(data))
  #low_value <- quantile(all_value,0.01,na.rm = T)
  row.names(data) <- minimunImputed()$sample
  data2 <- t(data)
  pc <- pca(data2,nPcs=2,method="ppca")
  imputed <- completeObs(pc)
  imputed[imputed<0] <- 0.01
  data <- cbind(minimunImputed()[,c(1,2,3,4,5)],as.data.frame(t(imputed)))
  return(data)
})

svdimpute <- eventReactive(input$svd, {
  data <- minimunImputed()[,-c(1,2,3,4,5)]
  #all_value <- as.numeric(as.matrix(data))
  #low_value <- quantile(all_value,0.01,na.rm = T)
  row.names(data) <- minimunImputed()$sample
  data2 <- t(data)
  pc <- pca(data2,nPcs=2,method="svdImpute")
  imputed <- completeObs(pc)
  imputed[imputed<0] <- 0.01
  data <- cbind(minimunImputed()[,c(1,2,3,4,5)],as.data.frame(t(imputed)))
  return(data)
})
#multiimpute <- eventReactive(input$multi, {
#  data <- minimunImputed()[,-c(1,2,3,4,5)]
#  all_value <- as.numeric(as.matrix(data))
#  low_value <- quantile(all_value,0.01,na.rm = T)
#  imp <- mice(data)
#  fit <- with(imp)
#  com <- pool(fit)
  #com[com<0] <- low_value
#  return(com)
#})


output$downloadknnData <- downloadHandler(
  filename = function() {
    paste("data-knnImputed", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(knnimpute(), file)
  }
)

output$downloadbpcaData <- downloadHandler(
  filename = function() {
    paste("data-bpcaImputed", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(bpcaimpute(), file)
  }
)

output$downloadmfData <- downloadHandler(
  filename = function() {
    paste("data-missforest-Imputed", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(missforestimpute(), file)
  }
)

output$downloadppcaData <- downloadHandler(
  filename = function() {
    paste("data-bpcaImputed", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(ppcaimpute(), file)
  }
)

output$downloadsvdData <- downloadHandler(
  filename = function() {
    paste("data-bpcaImputed", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(svdimpute(), file)
  }
)
#output$downloadmultiData <- downloadHandler(
 # filename = function() {
#    paste("data-multi_imputed", Sys.Date(), ".csv", sep="")
#  },
#  content = function(file) {
#    write.csv(multiimpute(), file)
#  }
#)

output$knnvalidateall <- renderPlot({
  pred <- mergedf()
  impd <- knnimpute()
  knntotal <- total_imp_pre_compare(pred,impd)
  print(knntotal)
})

output$knnvalidatemz <- renderPlot({
  pred <- mergedf()
  impd <- knnimpute()
  knnmz <- mz_wise_imputation_validataion(pred,impd)
  print(knnmz)
})

output$knnvalidatesample <- renderPlot({
  pred <- mergedf()
  impd <- knnimpute()
  knnsamp <- sample_wise_imputation_validation(pred,impd)
  print(knnsamp)
})

output$bpcavalidateall <- renderPlot({
  pred <- mergedf()
  impd <- bpcaimpute()
  bpcatotal <- total_imp_pre_compare(pred,impd)
  print(bpcatotal)
})

output$bpcavalidatemz <- renderPlot({
  pred <- mergedf()
  impd <- bpcaimpute()
  bpcamz <- mz_wise_imputation_validataion(pred,impd)
  print(bpcamz)
})

output$bpcavalidatesample <- renderPlot({
  pred <- mergedf()
  impd <- bpcaimpute()
  bpcasamp <- sample_wise_imputation_validation(pred,impd)
  print(bpcasamp)
})

output$mfvalidateall <- renderPlot({
  pred <- mergedf()
  impd <- missforestimpute()
  mftotal <- total_imp_pre_compare(pred,impd)
  print(mftotal)
})

output$mfvalidatemz <- renderPlot({
  pred <- mergedf()
  impd <- missforestimpute()
  mfmz <- mz_wise_imputation_validataion(pred,impd)
  print(mfmz)
})

output$mfvalidatesample <- renderPlot({
  pred <- mergedf()
  impd <- missforestimpute()
  mfsamp <- sample_wise_imputation_validation(pred,impd)
  print(mfsamp)
})

output$ppcavalidateall <- renderPlot({
  pred <- mergedf()
  impd <- ppcaimpute()
  ppcatotal <- total_imp_pre_compare(pred,impd)
  print(ppcatotal)
})

output$ppcavalidatemz <- renderPlot({
  pred <- mergedf()
  impd <- ppcaimpute()
  ppcamz <- mz_wise_imputation_validataion(pred,impd)
  print(ppcamz)
})

output$ppcavalidatesample <- renderPlot({
  pred <- mergedf()
  impd <- ppcaimpute()
  ppcasamp <- sample_wise_imputation_validation(pred,impd)
  print(ppcasamp)
})

output$svdvalidateall <- renderPlot({
  pred <- mergedf()
  impd <- svdimpute()
  svdtotal <- total_imp_pre_compare(pred,impd)
  print(svdtotal)
})

output$svdvalidatemz <- renderPlot({
  pred <- mergedf()
  impd <- svdimpute()
  svdmz <- mz_wise_imputation_validataion(pred,impd)
  print(svdmz)
})

output$svdvalidatesample <- renderPlot({
  pred <- mergedf()
  impd <- svdimpute()
  svdsamp <- sample_wise_imputation_validation(pred,impd)
  print(svdsamp)
})
#output$multivalidateall <- renderPlot({
#  pred <- mergedf()
#  impd <- multiimpute()
#  multitotal <- total_imp_pre_compare(pred,impd)
#  print(multitotal)
#})

#output$multivalidatemz <- renderPlot({
 # pred <- mergedf()
#  impd <- multiimpute()
#  multimz <- mz_wise_imputation_validataion(pred,impd)
#  print(multimz)
#})

#output$multivalidatesample <- renderPlot({
#  pred <- mergedf()
#  impd <- multiimpute()
#  multisamp <- sample_wise_imputation_validation(pred,impd)
#  print(multisamp)
#})

