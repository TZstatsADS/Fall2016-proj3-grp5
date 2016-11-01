#########################################################
### Train a classification model with training images ###
#########################################################


train = function(X, y, par=NULL){
  # Trains both the baseline and the advanced model
  # Input: 
  #   X =  matrix images*features  
  #   y = class labels for training images
  #   par = list of parameter values for both models
  #
  # Output: trained model objects for both models
  
  library("gbm")
  
  if(is.null(par)){
    depth = 1
    shrinkage = 0.1
    n.trees = 100
  } 
  else {
    eval(parse(text = paste(names(par), par, sep='=', collapse = ';')))
  }
  
  # Baseline model:
  BL_fit = gbm.fit(X, y,
                    distribution = "bernoulli",
                    n.trees = 100,
                    interaction.depth = 1, 
                    shrinkage = 0.1,
                    bag.fraction = 0.5,
                    verbose=FALSE)
  
  ntrees_BL = gbm.perf(gbm_fit, method="OOB")
  
  
  # Advanced model:
  
  
  return(list(BL_fit=BL_fit, 
              ntrees_BL=ntrees_BL))
  
}



