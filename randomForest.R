library(randomForest)
library(data.table)


X = fread("./data/sift_features.csv")
X = t(as.matrix(X))
y = c(rep(0,1000), rep(1, 1000))

K=5
n <- length(y)
n.fold <- floor(n/K)
s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))
cv.error <- rep(NA, K)
tm_train <- rep(NA, K)

for (i in 1:K){
  train.data <- X[s != i,]
  train.label <- y[s != i]
  test.data <- X[s == i,]
  test.label <- y[s == i]

  #fit <- randomForest(train.data, as.factor(train.label), ntree=100)
  tm_train[i] = system.time(fit <- tuneRF(train.data, as.factor(train.label), ntreeTry=50, doBest=TRUE))
  pred <- predict(fit, test.data)
  cv.error[i] <- mean(pred != test.label) 
}