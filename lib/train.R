##################################################
### Train the baseline and the advanced model  ###
##################################################


train = function(X, y, saveas=NULL){
  # INPUT: 
  #     X = matrix in images*features format
  #     y = class labels for training images
  #     saveas (optional): path and file name to save trained models, e.g. './output/models.RData'
  #
  # OUTPUT: trained model objects for both basline and advanced models
  
  source('./lib/cross_validation.R')
  source("./lib/train_BL.R")
  source("./lib/train_ADV.R")
  
  
  
  ############################################### BASELINE MODEL ###################################################### 
  
  # First, tune shrinkage parameter in BL model:
  shrinkages = seq(0.1, 0.5, 0.1) 
  test_err_BL = numeric(length(shrinkages))
  for(j in 1:length(shrinkages)){
    cat("BL model CV: j =", j, "of",length(shrinkages), "\n")
    
    par = list(depth=1, 
               shrinkage=shrinkages[j], 
               n.trees=100)
    
    test_err_BL[j] = cross_validation(X, y, par=par, K=5, model='BL')
  }
  
  cat('Grid of test error for BL model tuning: \n') 
  print(test_err_BL)   
  
  # Now train BL model on the whole data using optimal shrinkage value
  t = proc.time()
  shrinkage = shrinkages[which.min(test_err_BL)]
  par = list(depth=1, shrinkage=shrinkage, n.trees=100)
  BL_model = train_BL(X, y, par)
  
  cat("Baseline model training time:", (proc.time()-t)[3], " seconds \n")
  

  ############################################### ADVANCED MODEL ###################################################### 
  
  # First, tune depth and shrinkage parameters in ADV model:
  depths = seq(6, 10, 1)
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
  cat('Grid of test error for ADV model tuning: \n') 
  print(test_err_ADV) 
  
  # Now train ADV model on the whole data using optimal shrinkage value
  t = proc.time()
  ind_min = which(test_err_ADV == min(test_err_ADV), arr.ind = TRUE)
  depth = depths[ind_min[1]]
  shrinkage = shrinkages[ind_min[2]]
  par = list(depth=1, max_depth = depth, shrinkage=shrinkage, n.trees=100)
  par = list(objective = "binary:logistic",
             max_depth = depth,
             eta = shrinkage, 
             subsample = 0.5,
             nrounds = 40)
  ADV_model = train_ADV(X, y, par)
  
  cat("Advanced model training time:", (proc.time()-t)[3], " seconds \n")
  
  
  ############################################### RETURN RESULTS ###################################################### 
  
  models = list(BL_model = BL_model, ADV_model = ADV_model)
  
  if(!is.null(saveas))
    save(models, file = saveas)
  
  return(models)
  
}



