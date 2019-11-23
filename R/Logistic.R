#'Binomial Logistic regression
#'
#'Fit a generalized linear model via unpenalized maximum likelihood.
#'Use tuning-free optimization to get the result.
#'
#'@param X input matrix, of dimension n (sample number) by p (variable number);
#' each row is an observation vector.
#'@param y response variable.
#' Since we aim at binomial regression, it should be a vector with two levels (like a vector of 0 & 1, or a & b)
#'@param maxit the Maximum number of iterations when we use optimization to estimate the parameeter;
#'  default is 10000. And the algorithm will stop according to its stopping criterion.
#'@return A list containing the relevant data of regression result.
#'@examples
#'
#'### Generate training data
#'sigma<-4
#'set.seed(123)
#'n<-1e4
#'p<-1e2
#'mu1<-rnorm(p)
#'mu2<-rnorm(p)
#'X1<-matrix(mu1+rnorm(n*p,0,sigma),n,p,byrow = TRUE)
#'X2<-matrix(mu2+rnorm(n*p,0,sigma),n,p,byrow = TRUE)
#'
#'### Train data
#'X<-rbind(X1,X2)
#'y<-rep(c(1,0),each=n)
#'
#'### Fit model
#'fit<-Logreg(X,y)
#'
#'### accuracy of train data
#'fit$accuracy
#'
#'### check the convergence
#'plot(fit$loss)
#'
#'### get the prediction of train data
#'result<-fit$prediction
#'
#'### get the probability of each sample belonging to two category
#'result<-fit$P
#'
#'### get the parameter of the logistic regression (including intercept)
#'result<-fit$x
#'
#'@export
#'   

Logreg<-function(X,y,maxit = 10000){
  
  n<-dim(X)[1]
  X<-cbind(rep(1,n),X)
  p<-dim(X)[2]
  n0<- (n-1)%/%500
  extra_n<-500*(n0+1)-n
  tmp<-sample(1:n,extra_n,replace = TRUE)
  X<-rbind(X,X[tmp,])
  y<-c(y,y[tmp])
  n<-dim(X)[1]
  #We will use stochastic method to optimize, thus we randomly arrange them here
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
  pred[which(X%*%result$x > 0)]<- output[1]
  result$prediction <- pred
  result$accuracy <-  mean(result$prediction == y)
  result$label <-output
  return(result)
}


