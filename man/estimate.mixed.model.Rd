\name{estimate.mixed.model}
\alias{estimate.mixed.model}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{estimate.mixed.model
%%  ~~function to do ... ~~
}
\description{
Estimate the genetic variance component for a mixed model
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
estimate.mixed.model(y, kinship, make.positive=TRUE )
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y}{ numeric vector of quantitative phenotype values. names(y) must be defined.
%%     ~~Describe \code{x} here~~
}
  \item{kinship}{ symmetric numeric genetic relationship matrix. rownames(kinship) must be defined so that the rows and columns of the matrix corresponding to names(y) are identifiable }
  \item{make.positive}{ Boolean switch to test if kinship matrix is positive semi-definite based on its eigen-decomposition. Negative eigenvalues are truncated to zero. Default is TRUE. }
}
\details{
The mixed model assumes \eqn{ Var(y) = K\sigma^2_g + I\sigma^2_e}, where K is the kinship matrix and \eqn{ \sigma^2_g, \sigma^2_e} are the genetic and environmental variance components. This function uses the eigen-decomposition of the kinship matrix to find the maximum-likelihood estimates of the genetic and environmental variances and then computes a matrix equal to the square root of the inverse of\eqn{ V}, for use later for transforming the phenotype and genotypes in a mixed-model gwas.
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
A list with the following components:

\item{ y }{ A scaled and centred version of the phenotype vector with zero mean and variance unity. Any missing values are removed. }
\item{ K }{ A genetic relationship matrix with rows and columns rearranged to be in the same order as in y }
\item{vg}{ The genetic variance component}
\item{ve}{ The environmental variance component. Usually this is 1-vg}
\item{inv.sqrt.sigma}{ The inverse of the square root of the variance matrix, used for gwas}
\item{eigen.K}{The eigen decomposition of the kinship matrix}

%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Richard Mott
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
