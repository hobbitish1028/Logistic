## usethis namespace: start
#' @useDynLib Logistic, .registration = TRUE
## usethis namespace: end
NULL

## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
NULL


#'Binomial Logistic regression
#'
#'Fit a generalized linear model via penalized maximum likelihood.
#'The regularization path is computed for the lasso or elasticnet penalty
#'at a grid of values for the regularization parameter lambda.
#'Can deal with all shapes of data,including very large sparse data matrices.
#'
#' @param X input matrix, of dimension n (sample number) by p (variable number);
#' each row is an observation vector.
#' Can be in sparse matrix format
#' (inherit from class "sparseMatrix" as in package Matrix;
#' @param y response variable.
#' Since we aim at binomial distribution, it should be either a factor with two levels,
#'  or a two-column matrix (every row is the probability of two class.)
#' @param max_ite the Maximum number of iterations when we use optimization to estimate the parameeter;
#'  default is 10^5.
#'
#'  @return a data frame which contains the result of this logistic regression.
#'
#'  @param x the regression result, a length p+1 vector (include the intercept)
#'
#'  @param loss the record of loss in iterations, which can help users to check the convergence
#'
#'  @param Train_Acc the accuracy of the train set, defined as (number of right prediction divided by sample size)


# devtools::install_github("hobbitish1028/Logistic_Reg")

Logreg<-function(X,y,maxit = 5000){
  #library(Rcpp)
  #Rcpp::sourceCpp('LogRegCpp.cpp')
  Rcpp::sourceCpp('src/LogRegCpp.cpp')
  
  n<-dim(X)[1]
  X<-cbind(rep(1,n),X)
  p<-dim(X)[2]
  
  output<-unique(y)
  yy<- as.numeric(y==output[1])
  
  ### Use rcpp
  result <- LogRegcpp(X,rep(0,p),yy,maxit = maxit)
  result$loss <- result$loss[result$loss !=0 ]
  result$prediction <- result$P > 0.5
  pred<-rep(output[2],n)
  pred[which(result$P > 0.5)]<- output[1]
  result$prediction <- pred
  result$accuracy <- mean(result$prediction == y)
  result$label <-output
  return(result)
}


