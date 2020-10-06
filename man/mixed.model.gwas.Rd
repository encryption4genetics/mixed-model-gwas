\name{mixed.model.gwas}
\alias{mixed.model.gwas}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{mixed.model.gwas
%%  ~~function to do ... ~~
}
\description{ Perform a mixed-model genome-wide association analysis on SNP genotypes dosages.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
mixed.model.gwas( y, genotypes, kinship=NULL, nperm=0 )
}
%- maybe also 'usage' for other objects documented here.
\arguments{
   \item{y}{ numeric vector of quantitative phenotype values. names(y) must be defined.
%%     ~~Describe \code{x} here~~
}
  \item{genotypes}{ Matrix of SNP dosages}{ Each row corresponds to one individual, each column to one SNP. The rownames must be defined in order to matrch rows of the genotypes with the phenotype and kinship}
  \item{kinship}{ symmetric numeric genetic relationship matrix. rownames(kinship) must be defined so that the rows and columns of the matrix corresponding to names(y) are identifiable. If omitted then the kinship is computed from the genotypes. Default is NULL. }
  \item{nperm}{ Number of permutations to perform in order to determine genome-wide significance. Permutations are permformed after mixed-model transformation. Default is 0. }
}
\details{
The function first estimates the genetic \eqn{\sigma^2_g} and environmental \eqn{ \sigma^2_e} variance components under the assumption the quantitative trait has normally distributed residuals. It then uses this to model the phenotypic variance-covariance matrix as \eqn{ V= K \sigma^2_g+I \sigma^2_e} where \eqn{K} is the genetic relationship matrix, either provided explicitly or computed from the genotypes.

The mixed model transformation is
\deqn{ V^{-0.5}y = V^{-0.5}X\beta + V^{-0.5}e }
where \eqn{y} is the vector of phenotypes, \eqn{X} is a vector of genotype dosages for a given SNP, \eqn{\beta} is the fixed effect of the SNP, \eqn{e} is the vector of residuals. \eqn{V^{-0.5}} is the inverse of the matrix square root of \eqn{V}. This transformation makes the variance matrix of the treansformed residuals equal to the identity matrix.

Optionally genomewise significance is determined by performing permutations on the transformed quantitites (permutation is not valid on the untransformed data). The p-values of the test of association, along with the heritability of the trait, are returned.
}
\value{
  If nperm>0 returns a list with the following components:
  \item{pval}{numerical vector of pvalues of the test of association of the phenotype with each SNP, from a linear regression of the transformed phenotype on the transformed genotype dosage}
  \item{h2}{the estimated heritability of the trait, equal to the fraction of the total phenotypic variance explained by the genetic variance}
  \item{pval.perm}{Matrix with nperm columns. The i'th row is the vector of p-values of association between the transformed phenoypes and genotypes afteer permutation. }
  \item{pval.perm.empirical}{Vector containing for each SNP the fraction of permuted pvals that are smaller }
  \item{genomewide.pval}{The genomewide significance level of each SNP, defined as the fraction of permutations whose genomewide minimum is smaller.}
 If nperm=0 then the list only contains the components pval and h2.

    results = list( pval=pval, h2=mmd$vg)
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
function (x)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
