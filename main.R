#############################################
### Main execution script for experiments ###
#############################################

library(data.table)
source("./lib/feature.R")
source("./lib/test.R")


# load provided features:
X0 = fread('./data/sift_features.csv')
X0 = t(as.matrix(X0))


# Construct new visual features:
t = proc.time()
image_dir = "./data/images/"
X1 = feature(image_dir)
cat("Feature extraction time:", (proc.time()-t)[3], " seconds \n")


# train baseline and advanced models:
y = c(rep(1,1000), rep(0, 1000)) # labels: 0=dog, 1=chicken



# combine original and new features and save:
X = cbind(X0, X1)
save(X, file="./output/Feature_eval.RData")

# load("./output/Feature_eval.RData")


# make prediction
load("./output/BL_and_ADV_models.RData")
t = proc.time()
pred = test(models$ADV_model, X)
cat("Prediction time:", (proc.time()-t)[3], " seconds \n")

