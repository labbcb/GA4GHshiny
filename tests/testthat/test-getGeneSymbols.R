context("getGeneSymbols")

test_that("getGeneSymbols works", {
    library(org.Hs.eg.db)
    geneSymbols <- getGeneSymbols(orgDb = "org.Hs.eg.db")
    expect_is(geneSymbols, "character")
    expect_gt(length(geneSymbols), 1)
})
