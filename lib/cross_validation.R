########################
### Cross Validation ###
########################


cv.function <- function(X, y, d=1, shrinkage=0.001, n.trees=100, K=5){
  
  n <- length(y)
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error <- rep(NA, K)
  optimal_n_trees <- rep(NA, K)
  
  for (i in 1:K){
    train.data <- X[s != i,]
    train.label <- y[s != i]
    test.data <- X[s == i,]
    test.label <- y[s == i]
    
    par <- list(depth=d, shrinkage=shrinkage, n.trees = n.trees)
    fit <- train(train.data, train.label, par)
    pred <- test(fit, test.data)  
    
    cv.error[i] <- mean(pred != test.label) 
    optimal_n_trees[i] = fit$iter # optimal number of trees
    
  }			
  return(c(mean(cv.error), sd(cv.error), mean(optimal_n_trees), sd(optimal_n_trees)))
  
}
