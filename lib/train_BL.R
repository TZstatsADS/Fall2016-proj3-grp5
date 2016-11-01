

train_BL = function(X, y, par=NULL){
  # This function was used for tuning the baseline GBM model
  # Input: 
  #   X =  matrix images*features  
  #   y = class labels for training images
  #   par = list of values for params depth, shrinkage and n.trees
  #
  # Output: trained model object
  
  library("gbm")
  
  if(is.null(par)){
    depth = 1
    shrinkage = 0.1
    n.trees = 100
  } 
  else {
    depth = par$depth
    shrinkage = par$shrinkage
    n.trees = par$n.trees
  }
  
  gbm_fit = gbm.fit(X, y,
                    distribution = "bernoulli",
                    n.trees = n.trees,
                    interaction.depth = depth, 
                    shrinkage = shrinkage,
                    bag.fraction = 0.5,
                    verbose=FALSE)
  
  best_iter = gbm.perf(gbm_fit, method="OOB")
  
  return(list(fit=fit_gbm, iter=best_iter))
}
