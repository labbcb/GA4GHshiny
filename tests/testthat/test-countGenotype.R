context("countGenotype")

test_that("countGenotype works", {
  output <- countGenotype(list(c(0,0), c(0,1), c(1,2), c(1,1), c(2,2)))
  expect_equal(output, data.frame(
      ref.homozygous = 1,
      alt.heterozygous = 2,
      alt.homozygous = 2,
      total = 5
  ))
})
