context("getGene")

test_that("getGene works", {
    library(org.Hs.eg.db)
    library(TxDb.Hsapiens.UCSC.hg19.knownGene)
    gene <- getGene("SCN1A", orgDb = "org.Hs.eg.db",
        txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene")
    expect_s4_class(gene, "GRanges")
})