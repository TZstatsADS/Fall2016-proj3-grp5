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
  shrinkages = c(.0001, .001, .01, .1, .5)
  test_err = numeric(length(shrinkages))
  for(j in 1:length(shrinkages)){
    cat("j=", j, "\n")
    par = list(depth=1, shrinkage=shrinkages[j], n.trees=100)
    test_err[j] = cross_validation(X, y, par=par, K=5, model='BL')
  }
  
  
  # Now train BL model on all the data using optimal shrinkage value
  shrinkage = shrinkages(which.min(test_err))
  par = list(depth=1, shrinkage=shrinkage, n.trees=100)
  BL_fit = train_BL(train.data, train.label, par)
  

  ############################################### ADVANCED MODEL ###################################################### 
  
  
  
  
  
  ############################################### ADVANCED MODEL ###################################################### 
  
  return(list(BL_model = BL_fit, 
              ntrees_BL=ntrees_BL, 
              ADV_model = ADV_fit))
  
}



