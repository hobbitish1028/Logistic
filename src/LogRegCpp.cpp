#include <Rcpp.h>
#include <math.h>
using namespace Rcpp;

/// Matrix multiply a vector
NumericVector multi(Rcpp:: NumericMatrix X, Rcpp:: NumericVector beta, int nsites, int p){
  
  Rcpp:: NumericVector result(nsites);
  for(int j = 0; j < nsites; j++)
  {
    double temp = 0;
    
    for(int l = 0; l < p; l++) temp = temp + X(j,l) * beta[l];
    
    result[j] = temp;
  }
  
  return result;
}

/// Logistic regression
// [[Rcpp::export]]
List LogRegcpp(NumericMatrix X, NumericVector x, NumericVector y ,int maxit){
  
  int p = x.size();
  int n = y.size();
  
  NumericVector m(p);
  NumericVector v(p);
  for(int i = 0; i<p ; i++){
    m[i] = 0;
    v[i] = 1;
  } 
  ///default parameter of Nosadam algorithm
  double alpha = 5e-2;
  double beta_1 =0.9;
  double beta_2 = 0.9;
  int times = maxit;
  double gamma = 1e-2;
  
  NumericVector B(times+100); 
  B[0] = 1;
  for(int i=1;i<times+100;i++){
    B[i] = B[i-1] + pow( i,-gamma);  
  }
  
  NumericVector loss(times);
  NumericVector error(times);
  
  /// dafault batchsize is 500 
  NumericVector P0(500);
  NumericVector P(500);
  NumericVector gradient(p);
  
  for(int i=1; i < times ; i++){
    beta_2 = B[i+50] / B[i+51];
    //beta_2 = 0.99;
    NumericMatrix XX = X( Range( (i-1)*500 % n, (i*500-1) %n) , _ );
    NumericVector yy = y[Range( (i-1)*500 % n, (i*500-1) %n)];
    
    NumericVector P0 =  multi(XX ,x,500,p);
    
    P0 = exp(-P0);
    P = 1.0/ (1.0 + P0);
    
    NumericMatrix A2 = transpose(XX);
    NumericVector B2 = P - yy;
    NumericVector gradient =  multi(A2 ,B2,p,500);
    
    /// update parameter
    m = m * beta_1 + (1-beta_1) * gradient;
    v = v * beta_2 + (1-beta_2) * pow(gradient,2.0);
    x =   x - alpha / sqrt(i) * m / sqrt(v);
    
    /// calculate the loss function
    /// record every epoch's rather than every batch's loss to save time
    NumericVector P1 = log(P);
    NumericVector P2 = log(1-P);
   
    
    if( i %20 ==0){
      double loss0 = 0;
      NumericVector P0 =  multi(X ,x,n,p);
      P0 = exp(-P0);
      P = 1.0/ (1.0 + P0);
      NumericVector P1 = log(P);
      NumericVector P2 = log(1-P);
      for( int j =0;j< n;j++){
        if(y[j]==0){
          loss0  -= P2[j];
        }else{
          loss0  -= P1[j];
        }
      }
      
      loss[i/20] = loss0;  // Loss function is the log likelihood
    }
    
    /// stoping criteria
    if( i>3000 ){
      double mu = 0; 
      for(int j = i/20 -10; j < i/20 ; j++){
        mu += loss[j]; 
      }
      mu = mu /10;
      double s = 0;
      for(int j = i/20 -10; j < i/20; j++){
        s += pow(loss[j] - mu, 2.0);
      }  
      s = s/10;
      // if the loss converge, the break
      if(s < n/5e4){
        break;
      }
      
    }
    
  }
  
  return Rcpp::List::create(Rcpp::Named("x") = x,
                            Rcpp::Named("P") = P,
                            Rcpp::Named("loss") = loss);
}


