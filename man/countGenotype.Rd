% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/countGenotype.R
\name{countGenotype}
\alias{countGenotype}
\title{Count genotype}
\usage{
countGenotype(genotype)
}
\arguments{
\item{genotype}{list of integer vectors of length 2.}
}
\value{
\code{\link{data.frame}} of 1 row containing the columns below.

\itemize{
  \item ref.homozygous reference homosygous (e.g. 0/0);
  \item alt.heterozygous alternate heterozygous (e.g. 0/1, 1/2);
  \item ref.homozygous reference homozygous (e.g. 1/1, 2/2);
  \item total the sum of the three previous columns.
}
}
\description{
Summarize a list of genotype data. Variant calls with no
coverage (./.) do not enter in this count.
}
\examples{
countGenotype(genotype = list(c(0,0), c(0,1), c(1,2), c(1,1), c(2,2)))
}
