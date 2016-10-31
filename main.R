#############################################
### Main execution script for experiments ###
#############################################

library(data.table)

# img_train_dir <- "./data/images/"
# img_test_dir <- "./data/testing set/"

### Import matrix of features X and create vector of labels y
load("./output/features2.RData")
y = c(rep(1,1000), rep(0, 1000))


# ### Construct visual feature
# source("./lib/feature.R")
# tm_feature_train <- system.time(dat_train <- feature(img_train_dir, "img_zip_train"))
# tm_feature_test <- system.time(dat_test <- feature(img_test_dir, "img_zip_test"))
# save(dat_train, file="./output/feature_train.RData")
# save(dat_test, file="./output/feature_test.RData")



####### BASELINE MODEL: depth=1 (tree stumps) ###########################################################

# Model selection with cross-validation: hhoosing between different values of shrinkage for GBM
source("./lib/train.R")
source("./lib/test.R")
source("./lib/cross_validation.R")

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

