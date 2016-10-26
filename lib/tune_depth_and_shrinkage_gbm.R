
library(data.table)
source("./lib/train.R")
source("./lib/test.R")
source("./lib/cross_validation.R")


### Import matrix of features X and create vector of labels y
X = fread("./data/sift_features.csv")
X  = t(as.matrix(X))
y = c(rep(0,1000), rep(1, 1000))



# Cross-validation: choosing between different values of depth and shrinkage for GBM

depths = c(1, 3, 5, 7, 9)
shrinkages = c(.0001, .001, .01, .1, .5)

cv_output = array(dim=c(length(depths), length(shrinkages), 4))
for(i in 1:length(depths)){
  for(j in 1:length(shrinkages)){
    cat("i=", i,", j=", j, "\n")
    cv_output[i,j,] <- cv.function(X, y, d=depths[i], shrinkage=shrinkages[j], n.trees=1000, K=5)
  }
}


# summarize of CV results and save summary:
cv_gbm_tune_depth_shrink = list(def = 'cv_output= 3D array depth x shrinkage x measures',
                                depths = depths, 
                                shrinkages = shrinkages, 
                                measures = 'mean(Err), sd(Err), mean(optimal n.trees), sd(optimal n.trees)', 
                                cv_output = cv_output)

save(cv_gbm_tune_depth_shrink, file="./output/cv_gbm_tune_depth_shrink.Rdata")





