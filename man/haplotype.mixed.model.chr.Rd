\name{haplotype.dosage.mixed.model.chr}
\alias{haplotype.dosage.mixed.model.chr}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{haplotype.dosage.mixed.model.chr
%%  ~~function to do ... ~~
}
\description{
Perform a haplotype-based mixed model scan across a single chromosome
}
\usage{
haplotype.dosage.mixed.model.chr( mmd, haplotype.dosage, haplo.map, nperm=10, mc.cores=1, covar=NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mmd}{ A mixed-model data structure, as created by a previous call to \code{estimate.mixed.model}}
  \item{haplotype.dosage}{ Three-dimensional array of haplotype dosages of dimension \code{n.loci*n.individuals*n.founders}. }
  \item{haplo.map}{ A dataframe with \code{n.loci} rows, and with  columns containing the physical map of the loci to be tested. This information is combined with the genetic association p-values computed by the function.   }
  \item{nperm}{The number of permutations to perform}
  \item{mc.cores}{The number of compute cores over which to parallelise the computation}
  \item{covar}{Optional matrix of covariates}

%%     ~~Describe \code{x} here~~
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A list with the components
\item{logP}{Dataframe with the negative log10 of the p-values of haplotype-based association, columnds augmented by the input map }
\item{logP.perm}{The permutation-based matrix of p-values}
\item{beta}{Parameter estimates of the founder effects at each locus}
\item{se}{Standard errors of the founder effects}

%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{

}
\author{
Richard Mott
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

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
