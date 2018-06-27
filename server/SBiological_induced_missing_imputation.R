#======================================total group missing plotling=======================================================================
output$totalgroupmissedmz <- renderPlot({
  data <- datafiltered()
  miss_ratio_by_class <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$class),ratio_count)  #miss_ratio_by_class[,c(1:15)]
  total_group_missed_mz <- miss_ratio_by_class %>%     #head(total_group_missed_mz)
    melt(id=c("Group.1")) %>%
    filter(value == 1)
  # print(head(total_group_missed_mz))
  validate(
    need(nrow(total_group_missed_mz) >0, "No total group missed features")
  )
  data2 <- as.matrix(data[,-c(1,2,3,4,5)])
  row.names(data2) <- data$sample
  
  napostion <- is.na(data2)
  data2[napostion] <- 3
  data2[!napostion] <- 2
  for(i in c(1:nrow(total_group_missed_mz))){
    #i <- 1
    nn <- length(data2[grep(total_group_missed_mz$Group.1[i],data$class),grep(total_group_missed_mz$variable[i],colnames(data2))])
    data2[grep(total_group_missed_mz$Group.1[i],data$class),grep(total_group_missed_mz$variable[i],colnames(data2))] <- 1
  }
  data2 <- as.data.frame(data2)
  data2 <- data2[,!(apply(data2,2,function(x){all(x==2)}))]
  if(ncol(data2)>300){
    data2 <- data2[,c(1:300)]
  }
  list <- listData()
  k<-melt(cbind(sample=rownames(data2), data2),id="sample")
  kk<-merge(list,k,by.x = "sample",by.y = "sample")
  ggplot(kk, 
         aes(x = variable, y = sample, fill = factor(value))) + 
    geom_tile()+
    theme(axis.text.x = element_blank())+
    theme(axis.ticks.x = element_blank())+
    scale_y_discrete(breaks=kk$sample, labels = kk$class)+
    scale_fill_manual(values=c("red", "white", "blue"), 
                      breaks=c("1", "2", "3"),
                      labels=c("total group missing", "", "other missing data"))+
    theme(legend.position="top")+
    guides(fill=guide_legend(title=NULL))

})


#======================================total group missing handling=======================================================================
totalImputed <- reactive({
  data <- datafiltered()
  
  all_value <- as.numeric(as.matrix(data[,-c(1,2,3,4,5)]))
  low_value <- quantile(all_value,0.001,na.rm = T)
  all_low <- all_value[which(all_value<low_value)]
  mean_l <- mean(all_low,na.rm = T)
  sd_l <- sd(all_low,na.rm = T)
  
  miss_ratio_by_class <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$class),ratio_count)  #miss_ratio_by_class[,c(1:15)]
  total_group_missed_mz <- miss_ratio_by_class %>%     #head(total_group_missed_mz)
    melt(id=c("Group.1")) %>%
    filter(value == 1)
  data2 <- as.matrix(data[,-c(1,2,3,4,5)])
  for(i in c(1:nrow(total_group_missed_mz))){
    #i <- 1
    nn <- length(data2[grep(total_group_missed_mz$Group.1[i],data$class),grep(total_group_missed_mz$variable[i],colnames(data2))])
    data2[grep(total_group_missed_mz$Group.1[i],data$class),grep(total_group_missed_mz$variable[i],colnames(data2))] <- rnorm_fixed(nn,mean_l,sd_l)
    
  }
  data <- cbind(data[,c(1,2,3,4,5)],data2) #data[c(1:5),c(1:10)]
  return(data)
})
#======================================low abundance induced missing plotling=======================================================================
output$lowintensitymissing <- renderPlot({
  data <- totalImputed()
  value_ratio <- input$lowquantile
  miss_ratio <- input$misspercenthandling
  list <- listData()
  miss_ratio_by_class <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$class),ratio_count) #miss_ratio_by_class[,c(1:15)]
  mean_intensity_by_class <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$class),function(x){mean(as.numeric(as.character(x)),na.rm = T)}) #mean_intensity_by_class[,c(1:15)]
  a <- melt(miss_ratio_by_class,id=c("Group.1"))
  names(a) <- c("group","mz","ratio")
  a$gmz <- paste(a$group,a$mz,sep="_")
  b <- melt(mean_intensity_by_class,id=c("Group.1"))
  names(b) <- c("group","mz","intensity")
  b$gmz <- paste(b$group,b$mz,sep="_")
  ab <- merge(a,b,by.x = "gmz",by.y = "gmz")  #head(ab)
  #----------------
  all_value <- as.numeric(as.matrix(data[,-c(1,2,3,4,5)]))
  low_value <- quantile(all_value,value_ratio,na.rm = T)
  low_mz <- subset(ab,ratio>=miss_ratio & intensity<=low_value)  #head(low_mz)
  #----------------
  data2 <- as.matrix(data[,-c(1,2,3,4,5)])
  row.names(data2) <- data$sample
  data4 <- data2
  data5 <- data2
  napo <- is.na(data2)
  
  data4[!(is.na(data4))] <- NA
  for(i in c(1:nrow(low_mz))){
    class_mark <- grep(low_mz$group.x[i],data$class)
    mz_mark <- grep(low_mz$mz.x[i],colnames(data2))
    k<-which(is.na(data2[class_mark,mz_mark]))
    nn <- length(k)
    data4[class_mark[k],mz_mark]<- 1
  }
  data5 <- data5[,apply(data5,2,function(x){any(is.na(x))})]
  data5 <- as.data.frame(data5)
  data6 <- melt(cbind(sample=rownames(data5), data5))
  data6 <- data6[!(is.na(data6$value)),]
  
  data4 <- as.data.frame(data4)
  data8 <- melt(cbind(sample=rownames(data4), data4))
  data8 <- filter(data8,value==1)
  if(length(unique(data8$variable))>50){
    data8 <- data8[(data8$variable %in% unique(data8$variable)[c(1:50)]),]
    data6 <- data6[(data6$variable %in% unique(data8$variable)),]
    
  }
  data6<-merge(list,data6,by.x = "sample",by.y = "sample")
  
  ggplot(data6,aes(variable,sample,fill=log(value)))+
    geom_tile()+scale_fill_gradientn(colours = terrain.colors(10),name="log intensity")+
    geom_tile(aes(variable,sample),data=data8,fill="red")+
    theme(axis.text.x = element_blank())+
    theme(axis.ticks.x = element_blank())+
    scale_y_discrete(breaks=data6$sample, labels = data6$class)+
    theme(legend.position="top")
  
})
#======================================low abundance induced missing handling=======================================================================

minimunImputed <- reactive({
  data <- totalImputed()
  value_ratio <- input$lowquantile
  miss_ratio <- input$misspercenthandling
  miss_ratio_by_class <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$class),ratio_count) #miss_ratio_by_class[,c(1:15)]
  mean_intensity_by_class <- aggregate(data[,-c(1,2,3,4,5)],by=list(data$class),function(x){mean(as.numeric(as.character(x)),na.rm = T)}) #mean_intensity_by_class[,c(1:15)]
  a <- melt(miss_ratio_by_class,id=c("Group.1"))
  names(a) <- c("group","mz","ratio")
  a$gmz <- paste(a$group,a$mz,sep="_")
  b <- melt(mean_intensity_by_class,id=c("Group.1"))
  names(b) <- c("group","mz","intensity")
  b$gmz <- paste(b$group,b$mz,sep="_")
  ab <- merge(a,b,by.x = "gmz",by.y = "gmz")  #head(ab)
  #----------------
  all_value <- as.numeric(as.matrix(data[,-c(1,2,3,4,5)]))
  low_value <- quantile(all_value,value_ratio,na.rm = T)
  all_low <- all_value[which(all_value<low_value)]
  mean_l <- mean(all_low,na.rm = T)
  sd_l <- sd(all_low,na.rm = T)
  low_mz <- subset(ab,ratio>=miss_ratio & intensity<=low_value)  #head(low_mz)
  #----------------
  data2 <- as.matrix(data[,-c(1,2,3,4,5)])
  for(i in c(1:nrow(low_mz))){
    #i <- 1
    class_mark <- grep(low_mz$group.x[i],data$class)
    mz_mark <- grep(low_mz$mz.x[i],colnames(data2))
    k<-which(is.na(data2[class_mark,mz_mark]))
    nn <- length(k)
    data2[class_mark[k],mz_mark]<- rnorm_fixed(nn,mean_l,sd_l)
    # print(data2[class_mark[k],mz_mark])
  }
  data <- cbind(data[,c(1,2,3,4,5)],data2) #data[c(1:5),c(1:10)]
  return(data)
})




