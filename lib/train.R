##################################################
### Train the baseline and the advanced model  ###
##################################################


Train = function(X, y){
  # Input: 
  #   X =  matrix images*features  
  #   y = class labels for training images
  #
  # Output: trained model objects for both models
  
  source('./lib/cross_validation.R')
  source("./lib/train_BL.R")
  source("./lib/train_ADV.R")
  
  
  
  ############################################### BASELINE MODEL ###################################################### 
  
  # First, tune shrinkage parameter in BL model:
  shrinkages = c(.001, .01, .1, .5)
  test_err = numeric(length(shrinkages))
  for(j in 1:length(shrinkages)){
    cat("j=", j, "\n")
    par = list(depth=1, shrinkage=shrinkages[j], n.trees=100)
    test_err[j] = cross_validation(X, y, par=par, K=5, model='BL')
  }
  
  # Now train BL model on the whole data using optimal shrinkage value
  shrinkage = shrinkages[which.min(test_err)]
  par = list(depth=1, shrinkage=shrinkage, n.trees=100)
  BL_model = train_BL(X, y, par)
  

  ############################################### ADVANCED MODEL ###################################################### 
  
  library(data.table)
  library(xgboost)
  
  dtrain = xgb.DMatrix(data = X, label = y)
  depths = 7
  shrinkages = seq(0.1,0.5,0.1) # c(.001, .01, .1, .5)
  for (d in 1:length(depths)) {
    for(e in 1:5){
      cat("d=",d,"e=",e,'\n')
      
      param = list(objective = "binary:logistic",
                    max_depth = depths[d],
                    eta = shrinkages[e])
      
      mdcv <- xgb.cv(data=dtrain, params = param, 
                     nthread=6, 
                     nfold=5, 
                     nrounds=1000,
                     verbose = 0, 
                     early.stop.round=8, 
                     maximize=FALSE)
      
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
  
  
  
  ############################################### RETURN RESULT ###################################################### 
  
  return(list(BL_model = BL_fit, 
              ntrees_BL=ntrees_BL, 
              ADV_model = ADV_fit))
  
}



