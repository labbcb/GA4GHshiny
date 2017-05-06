context("initializeReferences")

test_that("initializeReferences works", {
    skip_on_bioc()
    data <- new("GA4GHSet", host = "http://1kgenomes.ga4gh.org/")
    data$datasets <- searchDatasets(data$host, nrows = 1)
    data$variantSets <- searchVariantSets(data$host,
        datasetId = data$datasets$id, nrows = 1)
    data <- initializeReferences(data, data$variantSets$id)
    expect_s4_class(data$references, "DataFrame")
    expect_equal(data$seqlevelsStyle, "NCBI")
})
