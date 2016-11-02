library(randomForest)

load("./output/features2.Rdata")
y = c(rep(1,1000), rep(0, 1000))

K=10
n <- length(y)
n.fold <- floor(n/K)
s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))
cv.error <- rep(NA, K)
time <- rep(NA, K)

for (i in 1:K){
  train.data <- X[s != i,]
  train.label <- y[s != i]
  test.data <- X[s == i,]
  test.label <- y[s == i]
  
  set.seed(415)
  
  #fit <- randomForest(train.data, as.factor(train.label), ntree=100)
  #time[i] = system.time(fit <- tuneRF(train.data, as.factor(train.label), ntreeTry=30, doBest=TRUE))
  time[i] = system.time(fit <- tuneRF(train.data, as.factor(train.label), doBest=TRUE))
  pred <- predict(fit, test.data)
  cv.error[i] <- mean(pred != test.label) 
}

ave.error = mean(cv.error)
sum.time = sum(time)
result = list(error=ave.error, time=sum.time, fit=fit)
write(result, file="./output/cv_RF.RData",append=TRUE)
