# Project: Labradoodle or Fried Chicken? 
![image](https://s-media-cache-ak0.pinimg.com/236x/6b/01/3c/6b013cd759c69d17ffd1b67b3c1fbbbf.jpg)
### [Full Project Description](doc/project3_desc.html)

Term: Fall 2016

+ Team #5
+ Team members
	+ Alex Saez
	+ Mengyuan Tao
	+ Zichen Wu
	+ Peiran Zhang
	+ Mengya Zhao
+ Project summary: In this project, we created a classification engine for images of poodles versus images of fried chicken. We added new color features which decrease our test error by a lot. At the same time, we several classifiers on our data, such as GBM, SVM, Random Forest and Neural Network. Among these models, we select GBM as our baseline and advanced model.   
	
**Contribution statement**:<br/>
Alex Saez tuned the baseline model, extracted the new color features and formatted the main code according to guidelines.<br/>
Mengyuan Tao...<br/>
Zichen Wu... <br/>
Peiran Fang ran Random Forest and tuned the model.<br/>
Mengya Zhao... <br/>


**Necessary libraries/packages:** <br/>

1. data.table
  * install.packages("data.table")
2. EBImage
  * source("https://bioconductor.org/biocLite.R")
  * biocLite("EBImage")
3. gbm
  * install.packages("gbm")
4. xgboost
  * install.packages("xgboost")


**R verion:** 3.3.1 <br/>
**Repository tested on Mac and Windows**

<br/>

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
