######################################################
### Fit the classification model with testing data ###
######################################################


test = function(fit_train, dat_test){
  
  ### Fit the classfication model with testing data
  
  ### Input: 
  ###  - the fitted classification model using training data
  ###  -  processed features from testing images 
  ### Output: training model specification
  
  library('gbm')
  library('xgboost')
  
  pred = switch(class(fit_train), 
                gbm = predict(fit_train, 
                              newdata = dat_test, 
                              n.trees = fit_train$n.trees, 
                              type="response"),
                
                xgb.Booster = predict(fit_train, 
                                      newdata = dat_test)
  )


  return(as.numeric(pred> 0.5))
}

