\name{haplotype.dosage.mixed.model}
\alias{haplotype.dosage.mixed.model}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
haplotype.dosage.mixed.model
}
\description{
Perform a haplotype-based association using a mixed linear model
}
\usage{

haplotype.dosage.mixed.model( phenfile, phenotype, id.column="IID",
                                          grm.datafile=NULL, # "RData/MAGIC.snp.grm.RData",
                                          dosage.dir=NULL, # "../../5STITCH/STITCH_haplotypes/LD_pruned_haplotypes",
                                          chrs, thin=1,  n.perm=0, mc.cores=1, covar=NULL)

}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{phenfile}{Path of the file contaning the phenotype data frame}
  \item{id.column}{The name of the column in the phenotype file containing the ids of the individuals}
  \item{grm.datafile}{Path to the RData file containing the genetic relationship matrix }
  \item{dosage.dir}{Path to the directory containing the haplotype dosage RData files}
  \item{chrs}{Vector of chromosome names to scan}
  \item{thin}{Thin out the loci by only testing association at 1/thin locations }
  \item{n.perm}{Number of permutations to perform}
  \item{mc.cores}{Number of cores to use during parallel computation}
  \item{covar}{Optionalmatrix of covariates}
%%     ~~Describe \code{x} here~~
}

\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
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
