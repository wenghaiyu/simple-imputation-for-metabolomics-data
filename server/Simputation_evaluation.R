
output$selgroup <- renderUI({
  list <- listData()
  list <- list[(list$class != "QC"),]
  classchoose <- unique(list$class)
  
  selectizeInput(# Replace with what you want to have in sidebarPanel
    'inputId' = "classsel"
    , 'label' = "Please select two class labels:"
    , 'choices' = classchoose
    , 'selected' = ""  # pick first column in dataset as names
    , multiple = TRUE
    , options = list(maxItems = 2)
  )
})

output$originPCA <- renderPlot({
  data1 <- mergedf()
  data <- as.matrix(data1[,-c(1,2,3,4,5)])
  sgroup <- data1[,3]
  rownames(data) <- data1$sample
  pc <- pca(data, nPcs=2, method="ppca")
  slplot(pc, sl=NULL, spch=5)
  plotd <- cbind(sgroup,as.data.frame(pc@scores))
  ggplot(plotd,aes(PC1,PC2))+
    geom_point(aes(colour=sgroup))+
    stat_ellipse(aes(x=PC1, y=PC2,color=sgroup),type = "norm")+
    labs(title="origin")
})




output$imp1PCA <- renderPlot({
  validate(
    need(input$impmethodsel != "", "Please choose two imputed results")
  )
  m <- input$impmethodsel
  titles1 <- m[1]
  data <- switch (titles1,
                  kNN = knnimpute(),bpca = bpcaimpute(),missforest = missforestimpute(),ppca=ppcaimpute(),lls=llsimpute(),svd=svdImpute()
  )
  validate(
    need(nrow(data) > 1, "Please choose a method that has been applied to your data")
  )
  pca_plot(data,titles1)
})

output$imp2PCA <- renderPlot({
  validate(
    need(input$impmethodsel[2] != "", "Please choose two imputed results")
  )
  m <- input$impmethodsel
  titles2 <- m[2]
  data <- switch (titles2,
                  kNN = knnimpute(),bpca = bpcaimpute(),missforest = missforestimpute(),ppca=ppcaimpute(),lls=llsimpute(),svd=svdImpute()
  )
  validate(
    need(nrow(data) > 1, "Please choose a method that has been applied to your data")
  )
  pca_plot(data,titles2)
})

output$imp1cluster <- renderPlot({
  validate(
    need(input$impmethodsel != "", "Please choose two imputed results")
  )
  m <- input$impmethodsel
  titles1 <- m[1]
  data <- switch (titles1,
                  kNN = knnimpute(),bpca = bpcaimpute(),missforest = missforestimpute(),ppca=ppcaimpute(),lls=llsimpute(),svd=svdImpute()
  )
  validate(
    need(nrow(data) > 1, "Please choose a method that has been applied to your data")
  )
  clu_plot(data,titles1)
})

output$imp2cluster <- renderPlot({
  validate(
    need(input$impmethodsel[2] != "", "Please choose two imputed results")
  )
  m <- input$impmethodsel
  titles2 <- m[2]
  data <- switch (titles2,
                  kNN = knnimpute(),bpca = bpcaimpute(),missforest = missforestimpute(),ppca=ppcaimpute(),lls=llsimpute(),svd=svdImpute()
  )
  validate(
    need(nrow(data) > 1, "Please choose a method that has been applied to your data")
  )
  clu_plot(data,titles2)
})

output$imp1acuarcy <- renderText({
  validate(
    need(input$impmethodsel != "", "Please choose two imputed results")
  )
  m <- input$impmethodsel
  titles1 <- m[1]
  data <- switch (titles1,
                  kNN = knnimpute(),bpca = bpcaimpute(),missforest = missforestimpute(),ppca=ppcaimpute(),lls=llsimpute(),svd=svdImpute()
  )
  validate(
    need(nrow(data) > 1, "Please choose a method that has been applied to your data")
  )
  ac <- pca_lda_classification_accuracy_cal(data)
  paste("the prediction accuarcy of ",titles1,"is: ",ac,"; ",sep = "")
})

output$imp2acuarcy <- renderText({
  validate(
    need(input$impmethodsel[2] != "", "Please choose two imputed results")
  )
  m <- input$impmethodsel
  titles2 <- m[2]
  data <- switch (titles2,
                  kNN = knnimpute(),bpca = bpcaimpute(),missforest = missforestimpute(),ppca=ppcaimpute(),lls=llsimpute(),svd=svdImpute()
  )
  validate(
    need(nrow(data) > 1, "Please choose a method that has been applied to your data")
  )
  ac <- pca_lda_classification_accuracy_cal(data)
  paste("the prediction accuarcy of ",titles2," is: ",ac,"; ",sep = "")
})

output$venndiffmz <- renderPlot({
  validate(
    need(length(input$impmethodsel)==2, "Please choose two imputed results")
  )
  validate(
    need(length(input$classsel)==2, "Please choose two biological groups")
  )
  m <- input$impmethodsel
  titles1 <- m[1]
  titles2 <- m[2]
  data1 <- switch (titles1,
                  kNN = knnimpute(),bpca = bpcaimpute(),missforest = missforestimpute()
  )
  data2 <- switch (titles2,
                  kNN = knnimpute(),bpca = bpcaimpute(),missforest = missforestimpute()
  )
  g <- input$classsel
  g1 <- g[1]
  g2 <- g[2]
  method1 <- different_express_single_pair(g1,g2,data1)
  method2 <- different_express_single_pair(g1,g2,data2)
  g1l <- length(method1)
  g2l <- length(method2)
  gt <- length(intersect(method1,method2))
  draw.pairwise.venn(
    area1 = g1l,
    area2 = g2l,
    cross.area = gt,
    category = c(titles1,titles2),
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


output$in1out2 <- renderPlot({
  validate(
    need(length(input$impmethodsel)==2, "Please choose two imputed results")
  )
  validate(
    need(length(input$classsel)==2, "Please choose two biological groups")
  )
  namem <- input$impmethodsel
  name1 <- namem[1]
  name2 <- namem[2]
  g <- input$classsel
  g1 <- g[1]
  g2 <- g[2]
  data1 <- switch(EXPR = name1, kNN = knnimpute(), bpca = bpcaimpute(), missforest = missforestimpute())
  data2 <- switch(EXPR = name2, kNN = knnimpute(), bpca = bpcaimpute(), missforest = missforestimpute())
  peaks <- minimunImputed()
  two_imp_diff_express_comparsion_in1_out2(peaks,data1,data2,name1,name2,g1,g2,1)
})

output$in2out1 <- renderPlot({
  validate(
    need(length(input$impmethodsel)==2, "Please choose two imputed results")
  )
  validate(
    need(length(input$classsel)==2, "Please choose two biological groups")
  )
  namem <- input$impmethodsel
  name1 <- namem[1]
  name2 <- namem[2]
  g <- input$classsel
  g1 <- g[1]
  g2 <- g[2]
  data1 <- switch(EXPR = name1, kNN = knnimpute(), bpca = bpcaimpute(), missforest = missforestimpute())
  data2 <- switch(EXPR = name2, kNN = knnimpute(), bpca = bpcaimpute(), missforest = missforestimpute())
  peaks <- mergedf()
  two_imp_diff_express_comparsion_in1_out2(peaks,data1,data2,name1,name2,g1,g2,2)
})



