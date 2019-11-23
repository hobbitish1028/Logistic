
test_that("multiplication works", {
  library(Logistic)
  library(glm2)
  sigma<-4
  set.seed(123)
  n<-1e4
  p<-1e2
  mu1<-rnorm(p)
  mu2<-rnorm(p)
  X1<-matrix(mu1+rnorm(n*p,0,sigma),n,p,byrow = TRUE)
  X2<-matrix(mu2+rnorm(n*p,0,sigma),n,p,byrow = TRUE)
  ### Train data
  X<-rbind(X1,X2)
  y<-rep(c(1,0),each=n)
  
  ##Accuracy of the training data and testing data
  fit<-Logreg(X,y)
  acc_mine<-fit$accuracy
  

  ### result of glm
  ### train accuracy
  dat<-as.data.frame(cbind(y,X))
  fit0<-glm(y~.,data=dat,family=binomial(link=logit))
  acc_glm<-(mean((fit0$fitted.values[1:n]>0.5) ) + mean((fit0$fitted.values[n+(1:n)]<0.5) ) )/2
  
  my_prediction<-My_predict(fit,newx = test_x)
  test_acc_mine<-mean(my_prediction == test_y)
  pred_glm <-cbind(rep(1,n),test_x) %*% fit0$coefficients
  test_acc_glm<- mean( pred_glm*rep(c(1,-1),each=n)>0  )
  
  expect_equal( ceiling(acc_mine*1e3),ceiling(acc_glm*1e3) )
  expect_equal( ceiling(test_acc_mine*1e3),ceiling(test_acc_glm*1e3) )
})
