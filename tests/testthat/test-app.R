context("app")

test_that("app works", {
    skip_on_bioc()
    appobj <- app("http://1kgenomes.ga4gh.org/", orgDb = "org.Hs.eg.db",
        txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene")
    expect_is(appobj, "shiny.appobj")
})
