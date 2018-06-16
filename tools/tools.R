single_sample_imp_validation <- function(x,pre,imp){
  #x <- sample_names[2]
  pre_da <- t(pre[x,-c(1,2,3,4,5)])
  miss_item <- which(is.na(pre_da))
  if(length(miss_item)>0){
    pre_da <- pre_da[-miss_item]
    imp_da <- t(imp[x,-c(1,2,3,4,5)])
    imp_da <- imp_da[miss_item]
    pre_df <- data.frame(
      mark="pre",
      intensity=pre_da
    )
    imp_df <- data.frame(
      mark="imp",
      intensity=imp_da
    )
    plot_D <- rbind(pre_df,imp_df)
  }else{
    plot_D <- data.frame(
      mark="pre",
      intensity=pre_da
    )
  }
  #print(head(plot_D))
  plot_D$sample <- pre[,1][x]
  return(plot_D)
}



sample_wise_imputation_validation <- function(pre,imp){
  #pre <- pre_data
  sample_xiabiao <- which(apply(pre,1,function(x){any(is.na(x))}))#get the samples that contain missing data
  #print("here")
  #print(sample_xiabiao)
  sample_names <- sample_xiabiao[ceiling(quantile(c(1:length(sample_xiabiao))))]
  #print(sample_names)
  names(sample_names) <- pre[,1][sample_names]
  a <- sample_names[1]
  plot_dat_p <- single_sample_imp_validation(a,pre,imp)
  #print(head(plot_dat_p))
  for(i in sample_names[-1]){
    x <- single_sample_imp_validation(i,pre,imp)
    plot_dat_p <- rbind(plot_dat_p,x)

  }


  plot_dat_p$sample <- as.character(plot_dat_p$sample)

  sample_validation_plot <- ggplot(plot_dat_p,aes(sample,log(intensity)))+
    geom_jitter(aes(colour=mark))+
    coord_flip()
    #theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
 # pdf(paste(visualization_out_dir,"validation_imputation_sample_wise.pdf",sep="/"))
  #print(sample_validation_plot)
  #dev.off()
  return(sample_validation_plot)
}

single_mz_imp_validation <- function(x,pre,imp){
  print(paste("x is:", x, sep = ""))
  print(imp[c(1:5),c(1:5)])
  #x <- 370
  pre_da <- pre[,x]
  miss_item <- which(is.na(pre_da))
  print(paste("missitem",miss_item),sep="")
  if(length(miss_item)>0){
    pre_da <- pre_da[-miss_item]
    print(imp[c(1:5),c(1:5)])
    print(paste("x",x,sep=""))
    imp_da <- imp[,x]
    imp_da <- imp_da[miss_item]
    pre_df <- data.frame(
      mark="pre",
      intensity=pre_da
    )
    imp_df <- data.frame(
      mark="imp",
      intensity=imp_da
    )
    plot_D <- rbind(pre_df,imp_df)
  }else{
    imp_df <- data.frame(
      mark="pre",
      intensity=pre_da
    )
  }
  
  plot_D$mz <- names(pre)[x]
  return(plot_D)
}

mz_wise_imputation_validataion <- function(pre,imp){
  
  mz_xiabiao <- which(apply(pre,2,function(x){any(is.na(x))}))#get the mzs that contain missing data
  mz_names <- mz_xiabiao[ceiling(quantile(c(1:length(mz_xiabiao)),probs = c(1:10)/10))]
  mz_names <- mz_names[-length(mz_names)]
  print(mz_names)
  names(mz_names) <- names(pre)[mz_names]
  plot_dat_p <- single_mz_imp_validation(mz_names[1],pre,imp)
  print("mark")
  print(head(plot_dat_p))
  for(i in mz_names[-1]){
    aa <- single_mz_imp_validation(i,pre,imp)
    print(paste("aa",i,sep=""))
    print(head(aa))
    plot_dat_p <- rbind(plot_dat_p,aa)
  }
  mz_validation_plot <- ggplot(plot_dat_p,aes(mz,log(intensity)))+
    geom_boxplot()+
    geom_jitter(aes(colour=mark))+
    coord_flip()
  return(mz_validation_plot)
   # theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
  #pdf(paste(visualization_out_dir,"validation_imputation_mz_wise.pdf",sep="/"))
  #print(mz_validation_plot)
  #dev.off()
  
}

total_imp_pre_compare <- function(pre,imp){
  pred <- pre[,-c(1:5)]
  impd <- imp[,-c(1:5)]
  nap <- is.na(pred)
  predd <- as.numeric(as.matrix(pred[!nap]))
  impdd <- as.numeric(as.matrix(impd[nap]))
  df <- data.frame(
    value =c(predd,impdd),
    mark =c(rep("pre",length(predd)),rep("imp",length(impdd)))
  )
  print(head(df))
  total_pre_imp <- ggplot(df,aes(mark,log(value)))+geom_boxplot()+geom_jitter()
  return(total_pre_imp)
}

different_express_single_pair <- function(compare_strs1,compare_strs2,data){
  
  ratio_p_cal <- function(x){
    # x <- data$`702.8818153`
    fenzi <- x[which(data$class==compare_strs1)]
    fenmu <- x[which(data$class==compare_strs2)]
    ratio <- mean(fenzi)/mean(fenmu)
    p_value <- t.test(fenzi,fenmu)$p.value
    out <- c(ratio,p_value)
    names(out) <- c("ratio","p")
    return(out)
  }
  
  ratio_p <- as.data.frame(t(apply(data[,-c(1,2,3,4,5)],2,ratio_p_cal)))
  sig_ratio_p <- row.names(subset(ratio_p,((ratio>=1.5 |ratio<=0.75) & p<=0.05)))
  
  return(sig_ratio_p)
}


pca_plot <- function(data,titlein){
  #get the data
  impdata <- as.matrix(data[,-c(1,2,3,4,5)])
  row.names(impdata) <- data$sample
  print(impdata[c(1:5),c(1:5)])
  diagnosis <- as.numeric(as.factor(data$class))
  #pca analysis
  imp.pr <- prcomp(impdata, scale = TRUE, center = TRUE)
  plotda <- cbind(as.data.frame(imp.pr$x[, c(1, 2)]),data$class)
  names(plotda)[3] <- "sgroup"
  ggplot(plotda,aes(PC1,PC2))+
    geom_point(aes(colour=sgroup))+
    stat_ellipse(aes(x=PC1, y=PC2,color=sgroup),type = "norm")+
    labs(title=titlein)
}


two_imp_diff_express_comparsion_in1_out2 <- function(peaks,data1,data2,name1,name2,g1,g2,direction){
  #peaks <- knn_impt@preimputed_dataset
  #data1 <- knn_impt@imputed_dataset
  #data2 <- missforest_imp@imputed_dataset
  #name1 <- "kNN"
  #name2 <- "missforest"
  #g1 <- unique(indata@listf$class)[2]
  #g2 <- unique(indata@listf$class)[3]
  sig_mz_1 <- different_express_single_pair(g1,g2,data1)
  sig_mz_2 <- different_express_single_pair(g1,g2,data2)
  
  #===========================comapre intensity==============================
  #in method 1 not in method 2
  if(direction == 1){
    in_method_1_out_method_2 <- setdiff(sig_mz_1,sig_mz_2)
    titleso<- paste("Different express features identified in ",name1,"imputed dataset but not in ", name2,"imputed dataset",sep = "")
  }
  if(direction == 2){
    in_method_1_out_method_2 <- setdiff(sig_mz_2,sig_mz_1)
    titleso<- paste("Different express features identified in ",name2,"imputed dataset but not in ", name1,"imputed dataset",sep = "")
  }
  
  if(length(in_method_1_out_method_2)>0){
    col_x <- c(3,which(names(peaks) %in% in_method_1_out_method_2))
  }
  if(length(col_x)>11){
    col_x <- col_x[c(1:11)]
  }
  row_x <- which((peaks$class==g1)|(peaks$class==g2))
  ori_da <- peaks[row_x,col_x]
  imp_da1 <- data1[row_x,col_x]
  imp_da2 <- data2[row_x,col_x]
  
  dd <- NULL
  for(i in c(2:ncol(ori_da))){
    #i <- 2
    d1 <- imp_da1[,c(1,i)]
    miss <- which(is.na(ori_da[,i]))
    d1$mark <- "origin"
    d1$mark[miss] <- "imputed"
    d1$method <- name1
    d2 <- imp_da2[,c(1,i)]
    d2$mark <- "origin"
    d2$mark[miss] <- "imputed"
    d2$method <- name2
    d <- rbind(d1,d2)
    d$mz <- names(d)[2]
    names(d)[2] <- "intensity"
    dd <- rbind(dd,d)
  }
  
  ggplot(dd,aes(class,log2(intensity),colour=mark))+geom_point()+facet_grid(method ~ mz)+
    labs(title=titleso)
  
}





