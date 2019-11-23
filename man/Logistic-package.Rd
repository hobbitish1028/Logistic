\name{Logistic-package}
\alias{Logistic-package}
\alias{Logistic}
\docType{package}
\title{
  Binomial Logistic Regression
}
\description{
  Use logistic regression model to predict binary output (like 0 & 1, a & b)
}
\details{
  There are two functions in the package, \code{Logreg} and \code{My_predict}. The \code{Logreg} function fits binomial logistic models. The \code{My_predict} function provides the default fitting method for \code{Logreg}. It is similar to \code{glm} in the \bold{glm2} package, except for modifications to the computational method that provide more stable convergence. 
}
\author{
Chang Wang (wangchan@umich.edu)

Maintainer: Chang Wang <wangchan@umich.edu>
}
\keyword{ package }
\examples{
  \dontrun{
     Refer to vignette for detailed examples
  }
}
