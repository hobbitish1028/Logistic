# Logistic
Perform binomial logistic regression

## Goal 
The goal of the package is to fit a binomial logistic regression via unpenalized maximum likelihood and to use the fitted model to make prediction on new data.

## Function
There are two functions in the package, `Logreg` and `My_predict`. The `Logreg` function fits binomial logistic models. The `My_predict` function provides the default fitting method for `Logreg`. It is similar to `glm` in the `glm2` package, except for modifications to the computational method that provide more stable convergence. 

## Detail about optimization method

We use adam-like algorithm (tuning-free optimization) to get the result. Besides, due to its theoretical superiority, it ususally performs better than SGD on data with high dimension (`p` is big).

We also give loss plot for user to check the convergence of optimization, while `glm` only give a warning or not to remind the user. Once we find the function diverge under some conditions, we can simply add to the parameter `maxit` to recover it.

Rcpp is used to speed up the loop part.

## Correctness and Efficiency
Although logistic regression is a strict convex question with a global maximum, since both models use stochastic optimization, they will converge to different solutions according to their stopping criterions and optimization rules. Thus we don't use `benchmark` here, and three digits of precision is already enough to make sure their convergence and consistency.

## Help

Use `?Logreg` and `?My_predict` to call help page.

And if you fail to call help page, please type `.rs.restartR()` and run it.
  
  
<!-- badges: start -->
  [![Travis build status](https://travis-ci.org/hobbitish1028/Logistic.svg?branch=master)](https://travis-ci.org/hobbitish1028/Logistic)
  <!-- badges: end -->
  
  <!-- badges: start -->
  [![Codecov test coverage](https://codecov.io/gh/hobbitish1028/Logistic/branch/master/graph/badge.svg)](https://codecov.io/gh/hobbitish1028/Logistic?branch=master)
  <!-- badges: end -->
