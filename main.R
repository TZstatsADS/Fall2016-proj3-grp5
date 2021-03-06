#############################################
### Main execution script for experiments ###
#############################################

library(data.table)
source("./lib/feature.R")
source("./lib/test.R")
source("./lib/train.R")


# load provided features:
X0 = fread('./data/sift features_test.csv')
X0 = t(as.matrix(X0))


# Construct new visual features:
t = proc.time()
image_dir = "./data/images_test/"
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
pred_BL = test(models$BL_model, X)
pred_ADV = test(models$ADV_model, X)
cat("Prediction time:", (proc.time()-t)[3], " seconds \n")

