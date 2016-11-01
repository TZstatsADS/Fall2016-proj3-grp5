#############################################
### Main execution script for experiments ###
#############################################

library(data.table)
source("./lib/train_BL.R")
source("./lib/train.R")
source("./lib/test.R")
source("./lib/cross_validation.R")
source("./lib/cross_validation_BL.R")
source("./lib/feature.R")



####### TUNE BASELINE MODEL: find optimal shrinkage parameter ############################################

# Model selection with cross-validation: hhoosing between different values of shrinkage for GBM

depth = 1
shrinkages = c(.0001, .001, .01, .1, .5)

cv_output = array(dim=c(length(shrinkages), 4))
for(j in 1:length(shrinkages)){
  cat("j=", j, "\n")
  cv_output[j,] <- cv.function(X, y, d=depth, shrinkage=shrinkages[j], n.trees=2000, K=5)
}


# summarize of CV results and save summary:
cv_gbm_depth1 = data.frame(shrink.val = shrinkages, 
                           mean.test.err = cv_output[,1], 
                           sd.test.err = cv_output[,2], 
                           mean.opt.ntrees = cv_output[,3], # mean optimal number of trees
                           sd.opt.ntrees = cv_output[,4]) # sd of optimal number of trees

print(cv_gbm_depth1)
save(cv_gbm_depth1, file="./output/cv_gbm_depth1.Rdata")


####### BASELINE MODEL:  ###########################################################


### Import matrix of features X and create vector of labels y

X = fread('./data/sift_features.csv')
X = t(as.matrix(X))
y = c(rep(1,1000), rep(0, 1000))





####### BASELINE MODEL WITH NEW FEATURES: ###########################################################

# load original features:
X0 = fread('./data/sift_features.csv')
X0 = t(as.matrix(X))

# Construct new visual features:
image_dir = "./data/images/"

t_features = system.time(X1 <- feature(image_dir))

# combine original and new features:
X = cbind(X0, X1)
  
# save(X, file="./output/features2.RData")
# load("./output/features2.RData")

# create labels
y = c(rep(1,1000), rep(0, 1000))

par = list(depth=1, shrinkage=0.1, n.trees=100)
cv_output = cv.function(X, y, par=par, K=5)

# Train the model with the entire training set using best combination of shrinkage value (for accuracy)
# and n.trees (for speed) based on the above CV results:
par_best = list(depth = 1, 
                shrinkage = 0.1, 
                n.trees = 100)

tm_train = system.time(fit_train_gbm_depth1 <- train(X, y, par_best))
save(fit_train_gbm_depth1, file="./output/fit_train_gbm_depth1.RData")



# ### Make prediction
# tm_test = system.time(pred_test <- test(fit_train, dat_test))
# save(pred_test, file="./output/pred_test.RData")

### Summarize Running Time
# cat("Time for constructing training features=", tm_feature_train[1], "s \n")
# cat("Time for constructing testing features=", tm_feature_test[1], "s \n")
cat("Time for training model=", tm_train[1], "s \n")
# cat("Time for making prediction=", tm_test[1], "s \n")

