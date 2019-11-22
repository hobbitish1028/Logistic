#'Binomial Logistic regression
#'
#'Fit a generalized linear model via penalized maximum likelihood.
#'The regularization path is computed for the lasso or elasticnet penalty
#'at a grid of values for the regularization parameter lambda.
#'Can deal with all shapes of data,including very large sparse data matrices.
#'
#'@param X input matrix, of dimension n (sample number) by p (variable number);
#' each row is an observation vector.
#' Can be in sparse matrix format
#' (inherit from class "sparseMatrix" as in package Matrix;
#'@param y response variable.
#' Since we aim at binomial distribution, it should be either a factor with two levels,
#'  or a two-column matrix (every row is the probability of two class.)
#'@param maxit the Maximum number of iterations when we use optimization to estimate the parameeter;
#'  default is 5000.
#'
#'@export
#'   

Logreg<-function(X,y,maxit = 10000){
  
  n<-dim(X)[1]
  X<-cbind(rep(1,n),X)
  p<-dim(X)[2]
 
  set.seed(1)
  tmp<-sample(1:n,n)
  X<-X[tmp,]
  y<-y[tmp]
  output<-unique(y)
  yy<- as.numeric(y==output[1])
  
  ### Use rcpp
  result <- LogRegcpp(X,rep(0,p),yy,maxit = maxit)
  result$loss <- result$loss[result$loss !=0 ]

  pred<-rep(output[2],n)
  pred[which(X%*%result$x > 0.5)]<- output[1]
  result$prediction <- pred
  result$accuracy <-   mean(result$prediction == yy)
  result$label <-output
  return(result)
}


