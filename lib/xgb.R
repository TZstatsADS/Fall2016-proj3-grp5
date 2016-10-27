install.packages(data.table)
library(data.table)
install.packages("xgboost")
library(xgboost)
X = read.csv("/Users/Guest/Desktop/sift_features.csv")
X  = t(as.matrix(X))
y = c(rep(1,1000), rep(0, 1000))

dtrain<-xgb.DMatrix(data = X,label = y)
best_param = list()
best_seednumber = 1234
best_err = Inf
best_err_index = 0
cv.result = data.frame(shk1=I(list()),shk2=I(list()),shk3=I(list()),shk4=I(list()),shk5=I(list()))
shrinkage = seq(0.1,0.5,0.1)
for (d in 6:10) {
  for(e in 1:5){
    try.maxdph = d
    try.eta = shrinkage[e]
    param <- list(objective = "binary:logistic",
                  max_depth = try.maxdph,
                  eta = try.eta
    )
    cv.nround = 1000
    cv.nfold = 5
    seed.number = sample.int(10000, 1)[[1]]
    set.seed(seed.number)
    cat("d=",d,"e=",e,'\n')
    mdcv <- xgb.cv(data=dtrain, params = param, nthread=6, 
                   nfold=cv.nfold, nrounds=cv.nround,
                   verbose = 0, early.stop.round=8, maximize=FALSE)
    min_err = min(mdcv[, test.error.mean])
    min_err_index = which.min(mdcv[, test.error.mean])
    cv.result[[d-5,e]] = list(min_err,min_err_index)
    if (min_err < best_err) {
      best_err = min_err
      best_err_index = min_err_index
      best_seednumber = seed.number
      best_param = param
    }
  }
}    

save(cv.result,file="./Desktop/cv_xgb_result.RData")
xgb_best<-data.frame(best_err,best_err_index,best_seednumber,best_param)
save(xgb_best,file="./Desktop/xgb_best.RData")


nround = best_err_index
set.seed(best_seednumber)
#md <- xgb.train(data=dtrain, params=best_param, nrounds=nround, nthread=6)
tm_train = system.time(md <- xgb.train(data=dtrain, params=best_param, nrounds=nround, nthread=6))

cat("Time for training model=", tm_train[1], "s \n")


