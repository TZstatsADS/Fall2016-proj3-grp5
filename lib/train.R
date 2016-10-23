#########################################################
### Train a classification model with training images ###
#########################################################


train <- function(dat_train, label_train, par=NULL){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  processed features from images 
  ###  -  class labels for training images
  ###  -  parameters for gbm.fit function
  ### Output: training model specification
  
  ### load libraries
  library("gbm")
  
  ### Train with gradient boosting model
  if(is.null(par)){
    depth = 1
    shrinkage = 1
    n.trees = 100
  } else {
    depth = par$depth
    shrinkage = par$shrinkage
    n.trees = par$n.trees
  }
  fit_gbm = gbm.fit(x=dat_train, y=label_train,
                     distribution = "bernoulli",
                     n.trees = n.trees,
                     interaction.depth = depth, 
                     shrinkage = shrinkage,
                     bag.fraction = 0.5,
                     verbose=FALSE)
  best_iter = gbm.perf(fit_gbm, method="OOB")

  return(list(fit=fit_gbm, iter=best_iter))
}
