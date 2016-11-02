#install.packages("neuralnet")
library(neuralnet)
load("/Users/monicatao/Documents/ads/project3/Fall2016-proj3-grp5/output/features2.Rdata")
y = c(rep(1,1000), rep(0, 1000))
set.seed(200)



K=5
n <- length(y)
n.fold <- floor(n/K)
s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))
hidden=rbind(1,2,3,4,5)
cv.error <- matrix(NA, nrow=K,ncol=nrow(hidden))

for (i in 1:K){
  train.data <- X[s != i,]
  train.label <- y[s != i]
  traindata=cbind(train.label,train.data)
  test.data <- X[s == i,]
  test.label <- y[s == i]
  
  f <- as.formula(paste("train.label ~", paste(colnames(train.data), collapse = " + ")))
  
  
  for(j in 1:nrow(hidden)){
    cat("k=",i,"j=",j,"\n")
    fit_nnet <- neuralnet(f,data=traindata,hidden=hidden[j,],linear.output = F)
    pred.nnet <- compute(fit_nnet, test.data) 
    pred <- as.numeric(pred.nnet$net.result>0.5)
    
    cv.error[i,j] <- mean(pred != test.label) 
  }
  
  
}


cv.error.nnet2<-cbind(apply(cv.error,2,mean),apply(cv.error,2,sd))

cv.error.nnet<-matrix(c(0.1345,0.02752271789,0.1490,0.03228776858,0.1445,0.03680183419,0.1380,0.007786205751,0.1450,0.020386883038),byrow = T,5)

cv.error.nnet<-rbind(cv.error.nnet2,cv.error.nnet,c(0.15,0.01045825033))

save(cv.error.nnet,file="cv_nnet.RData")
