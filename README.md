# Modelling App Installations and Minimizing Total Costs
A mobile app creator advertises his/her app on other apps through a mobile advertising platform to increase the app installs. The objective of the project is to develop a probability model that deems profitable to the company in terms of identifying right customers who would install the app. The best model is the one that minimizes the net expected advertising cost incurred to the app developer.<br/> 
The app install dataset has two issues to deal with – namely model selection and rare outcomes. PROC GLMSELECT and PROC HPLOGISTIC assist in selecting the predictors based on minimizing cross validation errors. To deal with rare outcomes, oversampling with weight-adjusted and offset-adjusted intercepts are utilized which result in less biased MLE estimates.<br/>
## About Data
The app advertisement is shown across 10 different apps on both iOS and Android devices with different mobile device characteristics. Each observation in the dataset corresponds to one ad shown to a consumer on a particular publisher app. The observation contains information about the publisher id, consumer’s device characteristics, and whether the advertiser’s app was installed or not. There are such 121, 339 instances recorded in the dataset.<br/>
[Data Description](./support/variables.jpg)
## Analysis
[Report](./report.pdf)
