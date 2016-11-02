#########################################################
### Train a classification model with training images ###
#########################################################


train_ADV = function(X, y, par){
  # Trains both the baseline and the advanced model
  # Input: 
  #   X =  matrix images*features  
  #   y = class labels for training images
  #   par = list of parameter values for both xgb.train
  #
  # Output: trained model objects for both models
  
  library('xgboost')
  
  dtrain = xgb.DMatrix(data = X, label = y)
  
  xgb_fit = xgb.train(data=dtrain, params=par, nrounds=par$nrounds)
  
  return(xgb_fit)
  
}



