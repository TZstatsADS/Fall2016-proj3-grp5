##################################################
### Train the baseline and the advanced model  ###
##################################################


train = function(X, y){
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
  test_err_BL = numeric(length(shrinkages))
  for(j in 1:length(shrinkages)){
    cat("BL model CV: j =", j, "of",length(shrinkages), "\n")
    
    par = list(depth=1, 
               shrinkage=shrinkages[j], 
               n.trees=100)
    
    test_err_BL[j] = cross_validation(X, y, par=par, K=5, model='BL')
  }
  
  print(test_err_BL)   
  
  # Now train BL model on the whole data using optimal shrinkage value
  shrinkage = shrinkages[which.min(test_err)]
  par = list(depth=1, shrinkage=shrinkage, n.trees=100)
  BL_model = train_BL(X, y, par)
  

  ############################################### ADVANCED MODEL ###################################################### 
  
  # First, tune depth and shrinkage parameters in ADV model:
  depths = 6:10
  shrinkages = seq(0.1, 0.5, 0.1) 
  test_err_ADV = array(dim=c(length(depths), length(shrinkages)))
  for (i in 1:length(depths)) {
    for(j in 1:length(shrinkages)){
      cat("ADV model CV: i =", i, "of",length(depths),", j =", j, "of",length(shrinkages), "\n")
      
      par = list(objective = "binary:logistic",
                 max_depth = depths[i],
                 eta = shrinkages[j], 
                 subsample = 0.5,
                 nrounds = 40)
      
      test_err_ADV[i,j] = cross_validation(X, y, par=par, K=5, model='ADV')
      
    }
  }
   
  print(test_err_ADV)   
  
  # Now train ADV model on the whole data using optimal shrinkage value
  ind_min = which(test_err == min(test_err), arr.ind = TRUE)
  depth = depths[ind_min[1]]
  shrinkage = shrinkages[ind_min[2]]
  par = list(depth=1, max_depth = depth, shrinkage=shrinkage, n.trees=100)
  par = list(objective = "binary:logistic",
             max_depth = depth,
             eta = shrinkage, 
             subsample = 0.5,
             nrounds = 40)
  ADV_model = train_ADV(X, y, par)
  
  
  ############################################### RETURN RESULT ###################################################### 
  
  BL_and_ADV_models = list(BL_model = BL_model, ADV_model = ADV_model)
  save(BL_and_ADV_models, file = './output/BL_and_ADV_models.RData')
  return(BL_and_ADV_models)
  
}



