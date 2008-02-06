\name{fpca.mle}
\alias{fpca.mle}
\title{Restricted MLE of Functional Principal Components}
\description{A function to obtain restricted MLE of functional principal components by Newton Ralphson algorithm for (sparsely and irregularly observed) longitudinal data.
  Subjects with only one measurement will be automatically excluded by 'fpca.mle'.
  Acknowledgements: The code for EM (as initial estimate) is provided by Professor G. James in USC (with slight modifications).
}
   
\usage{
fpca.mle(data.m, M.set,r.set, ini.method="EM", basis.method="bs", sl.v=rep(0.5,10), max.step=50,
grid.l=seq(0,1,0.01), grids=seq(0,1,0.002))
}

\arguments{
    \item{data.m}{Matrix with three columns. Each row corresponds to one measurement for one subject.
     Column One: subject ID (numeric or string); 
     Column 2: measurement (numeric); Column 3: corresponding measurement time (numeric);
     Missing values are not allowed.}
    \item{M.set}{numeric vector with integer values (>=4). Its element M is the number of basis functions used in the model for 
     representing the eigenfunctions.} 
    \item{r.set}{numeric vector with integer values (>=1). Its element r is the dimension of the process used in the model.} 
    \item{ini.method}{string. It specifies the initial method for Newton. Its value is either "EM" (default): EM algorithm by James et al. 2002;
     or "loc": the local linear method by Yao et al. 2005.}
    \item{basis.method}{string. It specifies the basis functions. Its value is either "bs" (default): cubic Bsplines with
     equally spaced knots; or "ns": natural splines. Given, basis.method, each combination of M and r specifies a model.} 
    \item{sl.v}{numeric vector. An ordinary Newton step has length 1 which could be too large in the initial few steps. 
    This vector specifies the step length for the first K steps, where K is the length of sl.v. If K >= max.step (see below), 
    then sl.v will be truncated at max.step. If K < max.step, then the steps after the K-th step will have length 1. 
    The default value of sl.v sets the first 10 steps of Newton to be of length 0.5.}           
    \item{max.step}{integer. It is the maximum number of iterations Newton will run. Newton will be terminated if max.step number 
    of iterations has been achieved even if it has not converged.}                      
    \item{grid.l}{numeric vector ranging from 0 to 1. This specifies the grid used by the local linear method (when "loc" is the initial method).
    Note that, due to the "sm" package used for fitting "loc", this grid can not be too dense.}
    \item{grids}{numeric vector ranging from 0 to 1. This specifies the grid used by EM (when EM is the initial method) and Newton. 
    Note that, for both grid.l and grids, the denser the grid is, the more computation is needed.}
   } 
\details{
    'fpca.mle' uses the Newton-Raphson algorithm on a \code{Stiefel manifold} to obtain the restricted maximum likelihood estimator of 
    the functional principal components from longitudinal data. It also performs model selection over (M and r) based on an approximate
    leave-one-curve-out cross validation score.} 

\value{
    A list with components
    \item{selected_model}{table. the selected M (number of basis functions) and r (dimension of the process).}
    \item{eigenfunctions}{numeric matrix. The estimated eigenfunctions under the selected model, evaluated at "grid" (see below).} 
    \item{eigenvalues}{numeric vector. The estimated eigenvalues under the selected model.}
    \item{error_var}{numeric value. The estimated error variance under the selected model.}
    \item{fitted_mean}{numeric vector. The estimated mean curve (by local linear fitting) evaluated at "grid".}
    \item{grid}{numeric vector ranging from L1 and L2. This is the grid of time points rescaled to fit the actual 
    time domain of the data, where L1 is the earliest time point, and L2 is the latest time point in the data.}
    \item{cv_scores}{numeric matrix. Approximate cv score for each combination of M and r.}
    \item{converge}{numeric matrix. Indicates the convergence of Newton for each combination of M and r. 
    If an entry is less than 1e-3, it indicates that Newton converged under the corresponding model; otherwise it 
    has not converged.}
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

\keyword{methods}

\examples{

##load data
data(example)

## candidate models
M.set<-c(4,5,6)    
r.set<-c(2,3,4)    

##parameters for fpca.mle
ini.method="EM"
basis.method="bs"
sl.v=rep(0.5,10)
max.step=50
grid.l=seq(0,1,0.01)
grids=seq(0,1,0.002)


##fit candidate models by fpca.mle

data.exp<-example[[1]]
result<-fpca.mle(data.exp, M.set,r.set,ini.method, basis.method,sl.v,max.step,
grid.l,grids)

##rescaled grid

grids.new<-result[[6]]

##model selection result: the true model M=5, r=3 is selected with smallest CV score among all converged models

M<-result[[1]][1]
r<-result[[1]][2]

##compare estimated eigenvalues with the truth

result[[3]]     ## estimated
example[[3]]    ## true

##compare estimated error variance with the truth

result[[4]]        ## estimated
example[[6]]^2     ## true

##plot: compare estimated eigenfunctions with the truth

eigenf<-example[[2]]  ##true
par(mfrow=c(2,2))
for(i in 1:r){
plot(grids.new,result[[2]][i,],ylim=range(result[[2]]),xlab="time",ylab=paste("eigenfunction",i))
points(grids, eigenf[i,],col=5,type="o")
}

##plot: compare estimated mean curve with the truth

plot(grids.new,result[[5]],xlab="time",ylab="mean curve",ylim=range(result[[2]]))
points(grids,numeric(length(grids)),col=5)

par(mfrow=c(1,1))

##look at the CV scores and convergence for each model: note that model (M=5, r=4) does not converge. 

result[[7]]   ##CV
result[[8]]   ##convergence
}