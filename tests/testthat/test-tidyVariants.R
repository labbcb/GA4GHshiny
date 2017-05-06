context("tidyVariants")

test_that("tidyVariants works with searchVariants output", {
    skip_on_bioc()
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariants(host, variantSetId, referenceName = "1",
        start = 15000, end = 16000, asVCF = FALSE)
    table <- tidyVariants(variants)
    expect_s3_class(table, "data.frame")
})

test_that("tidyVariants works with searchVariantsByGeneSymbol output", {
    skip_on_bioc()
    library(org.Hs.eg.db)
    library(TxDb.Hsapiens.UCSC.hg19.knownGene)
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariantsByGeneSymbol(host = host, 
        variantSetId = variantSetId,seqlevelsStyle = "NCBI",
        geneSymbol = "SCN1A", orgDb = "org.Hs.eg.db", 
        txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene", feature = transcripts)
    table <- tidyVariants(variants)
    expect_s3_class(table, "data.frame")
})
