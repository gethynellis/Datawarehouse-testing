# Regression Analysis of Structured Data With R

## Objectives

In this exercise, you will perform regression analysis on structured data using R. This exercise allows you to predict a target variable from a number of predictor variables. The goal is to show you how regression can be used to predict unknown values from a model trained on an existing data set.

### Overview
You will work on a data set called Prestige that is included with the car package. You will:
•	Review the distribution of the target variable
•	Examine the data set for correlated variables
•	Define a linear model that best describes data from which we can make future predictions

Open RStudio which is installed on your lab machine an


1. Load the car library

 `library(car)`

2. Examine the structure of the Prestige data set
` str(Prestige) `

3. Examine the distribution of the target variable prestige within the Prestige data set
`summary(Prestige$prestige)`

4. Generate a histogram of the variable
`hist(Prestige$prestige)`

5. Take a look at the distribution of the levels of the type attribute
`table(Prestige$type)`

6. Create a correlation matrix to examine the relationship between the income and education variables
`cor(Prestige$income, Prestige$education)`

7. Create a correlation matrix to examine the relationship between the income, education, and women variables
`cor(Prestige[c("education","income","women")])`

8. Visualize the relationship among these three variables
`pairs(Prestige[c("education","income","women")])`

9. Load the stats library
`library(stats)`

10. Using the lm() function from the stats package, fit a linear  regression model to relate the independent variables to the total
`pres_model <- lm(prestige ~ ., data = Prestige)`

`pres_model <- lm(prestige ~ education + women + income + type, data = Prestige)`
` pres_predict <- predict(pres_model, pres_test)`

11. View the model to see the estimated coefficients
`pres_model`

 12. Evaluate the model to see how well the model fits the data
`summary(pres_model)`
