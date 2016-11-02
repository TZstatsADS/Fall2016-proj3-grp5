
train_ADV = function(X, y, par){
  # Training function for the advanced model
  # INPUT: 
  #   X =  matrix in images*features format
  #   y = class labels for training images
  #   par = list of parameter values for xgb.train
  #
  # OUTPUT: trained model object
  
  library('xgboost')
  
  dtrain = xgb.DMatrix(data = X, label = y)
  
  xgb_fit = xgb.train(data=dtrain, params=par, nrounds=par$nrounds)
  
  return(xgb_fit)
  
}



