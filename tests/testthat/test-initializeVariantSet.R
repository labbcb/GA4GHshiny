context("initializeVariantSet")

test_that("initializeVariantSet works", {
    skip_on_bioc()
    data <- new("GA4GHSet", host = "http://1kgenomes.ga4gh.org/")
    data$datasets <- searchDatasets(data$host, nrows = 1)
    data <- initializeVariantSet(data, data$datasets$id)
    expect_s4_class(data$variantSets, "DataFrame")
})
