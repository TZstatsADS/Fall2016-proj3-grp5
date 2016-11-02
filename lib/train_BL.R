

train_BL = function(X, y, par=NULL){
  # Train baseline model (GBM)
  # Input: 
  #   X =  matrix images*features  
  #   y = class labels for training images
  #   par = list of values for params depth, shrinkage and n.trees
  #
  # Output: trained model object
  
  library('gbm')

  if(is.null(par)){
    depth = 1
    shrinkage = 0.1
    n.trees = 100
  } 
  else {
    eval(parse(text = paste(names(par), par, sep='=', collapse = ';')))
  }
  
  gbm_fit = gbm.fit(X, y,
                    distribution = "bernoulli",
                    n.trees = n.trees,
                    interaction.depth = depth, 
                    shrinkage = shrinkage,
                    bag.fraction = 0.5,
                    verbose=FALSE)
  
  return(gbm_fit)
}
