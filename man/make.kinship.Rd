\name{make.kinship}
\alias{make.kinship}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{make.kinship
%%  ~~function to do ... ~~
}
\description{
Construct the genetic relationship matrix from the matrix of genotype dosages
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
make.kinship(genotypes, scale.genos = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{genotypes}{Matrix of genotype dosages. Each row is one individual and each column is one SNP. The rownames of the  matrix must be defined as these are used to name the rows and columns of the kinship matrix
%%     ~~Describe \code{genotypes} here~~
}
  \item{scale.genos}{Optional switch to scale each column of genotypes by it empirical mean abd standard deviation. Computation is safe in the presence of missing values, which are set to the column mean. Default is TRUE.
%%     ~~Describe \code{scale.genos} here~~
}
}
\details{
The kinship is defined as \eqn{ K=G G^T} where \eqn{G} is the (by default standardised) matrix of genotype dosages.
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A symmetic matrix with dimensions equal to thee number of rows in thee genotype matrix. The rownames and colnames attributes are the same as in the genotype matrix.
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
function (genotypes, scale.genos = FALSE)
{
    if (scale.genos) {
        genos = apply(genotypes, 2, function(g) {
            s = sd(g, na.rm = TRUE)
            mu = mean(g, na.rm = TRUE)
            if (s > 0) {
                g = ifelse(is.na(g), 0, (g - mu)/s)
            }
            else {
                g = rep(0, length(g))
            }
            return(g)
        })
        rownames(genos) = rownames(genotypes)
        genotypes = genos
    }
    kinship = genotypes \%*\% t(genotypes)/(ncol(genotypes) - 1)
    colnames(kinship) = rownames(genotypes)
    rownames(kinship) = rownames(genotypes)
    cat("Built kinship dim", dim(kinship), "\n")
    return(kinship)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
