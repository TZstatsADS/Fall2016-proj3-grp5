#############################################
### Main execution script for experiments ###
#############################################

library(data.table)
<<<<<<< HEAD

# img_train_dir <- "./data/images/"
# img_test_dir <- "./data/testing set/"

### Import matrix of features X and create vector of labels y
load("./output/features2.RData")
y = c(rep(1,1000), rep(0, 1000))

#####Add feature names
siftname = vector()
for(i in 1:5000){
  siftname[i]<-paste0("SIFT",i)
}
for(i in 5001:6000){
  siftname[i]<-paste0("Color",i-5000)
}
colnames(X)<-siftname

# ### Construct visual feature
# source("./lib/feature.R")
# tm_feature_train <- system.time(dat_train <- feature(img_train_dir, "img_zip_train"))
# tm_feature_test <- system.time(dat_test <- feature(img_test_dir, "img_zip_test"))
# save(dat_train, file="./output/feature_train.RData")
# save(dat_test, file="./output/feature_test.RData")



####### BASELINE MODEL: depth=1 (tree stumps) ###########################################################

# Model selection with cross-validation: hhoosing between different values of shrinkage for GBM
source("./lib/train.R")
=======
source("./lib/feature.R")
>>>>>>> origin/master
source("./lib/test.R")
source("./lib/train.R")


# load provided features:
X0 = fread('./data/sift_features.csv')
X0 = t(as.matrix(X0))


# Construct new visual features:
t = proc.time()
image_dir = "./data/images/"
X1 = feature(image_dir)
cat("Feature extraction time:", (proc.time()-t)[3], " seconds \n")


# combine original and new features and save:
X = cbind(X0, X1)
save(X, file="./output/Feature_eval.RData")

# load("./output/Feature_eval.RData")


# train baseline and advanced models:
y = c(rep(1,1000), rep(0, 1000)) # labels: 0=dog, 1=chicken
models = train(X, y, saveas='./output/BL_and_ADV_models.RData')


# make prediction
load("./output/BL_and_ADV_models.RData")
t = proc.time()
pred = test(models$ADV_model, X)
cat("Prediction time:", (proc.time()-t)[3], " seconds \n")

