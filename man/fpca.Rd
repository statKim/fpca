\name{fpca}
\alias{fpca}
\title{The fpca package: summary information}
\description{The package implements the Newton Ralphson procedure to estimate functional principal components from (sparsely and irregularly observed)
longitudinal data described in Peng and Paul (2007).
}
\details{Missing values are not allowed. Subjects with only one measurement will be automatically excluded. 
The main function is 'fpca.mle'. A simulated data set can be called by 'data(example)'. Type 'help(example)' to see details.
Packages 'sm' and 'splines' are used by this package.  The code for EM (as initial estimate) is provided by Professor G. James in USC (with slight modifications).
}

\references{
Peng, J. and Paul, D. (2007).  
A geometric approach to maximum likelihood estimation of the functional principal components from sparse longitudinal data
 (arXiv:0710.5343v1 [stat.ME]) 

James, G. M., Hastie, T. J. and Sugar, C. A. (2000) Principal component models for sparse
functional data. Biometrika, 87, 587-602.

Yao, F., Mueller, H.-G. and Wang, J.-L. (2005) Functional data analysis for sparse longitudinal
data. Journal of the American Statistical Association 100, 577-590

}

\author{J. Peng, D. Paul}
\keyword{package}