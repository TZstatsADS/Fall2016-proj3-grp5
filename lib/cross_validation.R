
# Cross validation function for either the baseline or the advanced model

cross_validation = function(X, y, par=NULL, K=5, model='BL'){
  # Input: 
  #   X =  matrix images*features  
  #   y = class labels for training images
  #   K = number of folds
  #   par = list of parameter values, passed on directly to training functions
  #   moldel = either 'BL' or 'ADV' for baseline or advanced model
  #
  # Output: mean test error over all folds
  
  source("./lib/train_BL.R")
  source("./lib/train_ADV.R")
  source("./lib/test.R")
  
  n = length(y)
  n.fold = floor(n/K)
  s = sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error = rep(NA, K)
  
  for (i in 1:K){
    train.data = X[s != i,]
    train.label = y[s != i]
    test.data = X[s == i,]
    test.label = y[s == i]
    
    fit = switch(model,
                 BL = train_BL(train.data, train.label, par),
                 ADV = train_ADV(train.data, train.label, par)
    )
    
    pred = test(fit, test.data)  
    
    cv.error[i] = mean(pred != test.label) 
    
  }			
  
  return(mean(cv.error))
  
}
