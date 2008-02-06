\name{example}
\alias{example}
\title{An example}
\description{A simulated dataset as an example}
\format{
example is a list with six components (in the given order):
\describe{
\item{data.exp}{data matrix with three columns: column 1--ID, column 2--measurement, column 3--time of measurement.}
\item{eigenf}{true eigenfunctions: generated from cubic Bsplines with five equally spaced knots.}
\item{eigenv}{true eigenvalues: first--1, second--0.66, third--0.52, others--zero.}
\item{M.tr}{true number of basis functions: 5.}
\item{r.tr}{true dimension of the process: 3.}
\item{sig.tr}{true error standard deviation: 0.25.}
 }
}

\details{mean curve of the process is zero; principal component scores and errors are all i.i.d N(0,1); there are 200 subjects, and each has 
2~10 measurements uniformly distributed on [0,1]; in total there are 1227 measurements}
\usage{data(example)}
\keyword{datasets}