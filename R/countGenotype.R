#' @title Count genotype
#' @description Summarize a list of genotype data. Variant calls with no
#' coverage (./.) do not enter in this count.
#' @param genotype list of integer vectors of length 2.
#' @return \code{\link{data.frame}} of 1 row containing the columns below.
#'
#' \itemize{
#'   \item ref.homozygous reference homosygous (e.g. 0/0);
#'   \item alt.heterozygous alternate heterozygous (e.g. 0/1, 1/2);
#'   \item ref.homozygous reference homozygous (e.g. 1/1, 2/2);
#'   \item total the sum of the three previous columns.
#' }
#' @examples
#' countGenotype(genotype = list(c(0,0), c(0,1), c(1,2), c(1,1), c(2,2)))
#' @export countGenotype
countGenotype <- function(genotype)
{
    ref.homozygous <- genotype %>%
        map_lgl(isRefHomozygous) %>%
        sum(na.rm = TRUE)
    alt.heterozygous <- genotype %>%
        map_lgl(isAltHeterozygous) %>%
        sum(na.rm = TRUE)
    alt.homozygous <- genotype %>%
        map_lgl(isAltHomozygous) %>%
        sum(na.rm = TRUE)
    total <- ref.homozygous + alt.heterozygous + alt.homozygous
    data.frame(ref.homozygous, alt.heterozygous, alt.homozygous, total)
}
