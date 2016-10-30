library(e1071)

set.seed(3)

load("~/Documents/Columbia/Fall 2016/Applied Data Anaylsis/Project3/features2.Rdata")

data_train = rbind(X[1:800,],X[1001:1800,])
data_test = rbind(X[801:1000,],X[1801:2000,])

y1 = c(rep(0,800),rep(1,800))
y2 = c(rep(0,200),rep(1:200))

#SVM radial kernal#

data.tune = tune(svm,data_train,y1,kernel = "radial",ranges = list(cost = c(0.01,0.1,1,5,10)))
data.tune.best = data.tune$best.parameters

data.svm = svm(data_train,y1,kernel = "radial",cost = data.tune.best)
train.predict = predict(data.svm,data_train)
test.predict = predict(data.svm,data_test)

train.error = (sum(train.predict[1:800] > 0.5) + sum(train.predict[801:1600] < 0.5))/1600
test.error = (sum(test.predict[1:200] > 0.5) + sum(test.predict[201:400] < 0.5))/400

c(train.error,test.error)


#SVM polynomial kernal#

data.tune2 = tune(svm,data_train,y1,kernel = "polynomial",ranges = list(cost = c(10,50,100,500,1000)))
data.tune.best2 = data.tune2$best.parameters

data.svm2 = svm(data_train,y1,kernel = "polynomial",cost = data.tune.best2)
train.predict2 = predict(data.svm2,data_train)
test.predict2 = predict(data.svm2,data_test)

train.error2 = (sum(train.predict2[1:800] > 0.5) + sum(train.predict2[801:1600] < 0.5))/1600
test.error2 = (sum(test.predict2[1:200] > 0.5) + sum(test.predict2[201:400] < 0.5))/400

c(train.error2,test.error2)












