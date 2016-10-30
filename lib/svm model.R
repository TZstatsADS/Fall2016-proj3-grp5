install.packages("e1071")
library(e1071)
load("/Users/monicatao/Documents/ads/project3/Fall2016-proj3-grp5/output/features2.Rdata")
y = c(rep(1,1000), rep(0, 1000))

########Tune the model by 10-fold Cross validation

####SVM with linear kernel
set.seed(200)
tune_linear<-tune.svm(X,y,kernal ="linear",cost = c(10000,50000,100000))

#####SVM with radial kernel
set.seed(1234)
tune_radial<-tune.svm(X,y,kernel = "radial",cost = c(1000,10000,20000),gamma = c(0.5,1,2))
print(tune_radial)
plot(tune_radial)
save(tune_radial,file="svm_radial.RData")



#########################################################
### Train a classification model with training images ###
#########################################################


train <- function(dat_train, label_train, par=NULL){
  
  if(is.null(par)){
    cost = 10000
    kernel = "linear"
    gamma = 0.0001666667
  } else {
    kernel = par$kernel
    cost = par$cost
    gamma = par$gamma
  }
  fit_svm = svm(x=dat_train, y=label_train,
                type="C-classification",
                kernel = kernel,
                cost = cost,
                gamma = gamma,
                scale=FALSE)
  
  return(fit_svm)
}


###################################
#######Test data for SVM model#####
###################################

test <- function(fit_train, dat_test){

  pred <- predict(fit_train$fit, newdata=dat_test)
  
  return(as.numeric(pred> 0.5))
}



#######Train the model#########

#####SVM with linear kernel
par_best_linear = list(cost = 10000)
tm_train_svm_linear = system.time(fit_train_svm_linear <- train(X, y))
save(fit_train_svm_linear, file = "fit_train_svm_linear.RData")


#######SVM with radial kernel 
par_best_radial = list(kernel = "radial",
                       cost = 1000,
                       gamma = 2)
tm_train_svm_radial = system.time(fit_train_svm_radial <- train(X, y, par_best_radial))
save(fit_train_svm_radial, file = "fit_train_svm_radial.RData")


######SVM with polynomial kernel
#par_best_radial = list(kernel = "polynomial",
#                       cost = ,
#                       gamma = ,
#                       degree = )
#tm_train_svm_polynomial = system.time(fit_train_svm_polynomial <- train(X, y, par_best_polynomial))




