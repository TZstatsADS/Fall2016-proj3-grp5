library(verification)
library(randomForest)

### Specify directories
setwd("C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Project3/Fall2016-proj3-grp5")
load("output/features2.Rdata")



siftname = vector()
for(i in 1:5000){
  siftname[i]<-paste0("SIFT",i)
}
for(i in 5001:6000){
  siftname[i]<-paste0("Color",i-5000)
}
colnames(X)<-siftname

y_train <- c(rep(1,1000), rep(0, 1000))

#random forest:
#rf <- randomForest(X, ntree = 10)
#rf$err.rate

model1 <- randomForest(X, y_train, ntree = 10)
model2 <- randomForest(X, y_train, ntree = 1000)


feature_importance <- as.data.frame(importance(model1))
Names <- colnames(X)
feature_name <- paste(rep(Names, 6000), 1:6000, sep = '')
importance <- cbind(feature_importance, feature_name)
importance <- importance[order(-importance$IncNodePurity),]
select_feature <- importance[importance$IncNodePurity > 0,]$feature_name
select_train.data.x <- X[, select_feature]
dim(select_train.data.x)






