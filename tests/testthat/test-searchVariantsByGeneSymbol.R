context("searchVariantsByGeneSymbol")

library(org.Hs.eg.db)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)

test_that("searchVariantsByGeneSymbol works", {
    skip_on_bioc()
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariantsByGeneSymbol(host = host, 
        variantSetId = variantSetId,seqlevelsStyle = "NCBI",
        geneSymbol = "SCN1A", orgDb = "org.Hs.eg.db",
        txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene") 
    expect_s4_class(variants, "DataFrame")
    expect_equal(dim(variants), c(4227, 33))
})

test_that("searchVariantsByGeneSymbol feature=transcripts works", {
    skip_on_bioc()
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariantsByGeneSymbol(host = host, 
        variantSetId = variantSetId,seqlevelsStyle = "NCBI",
        geneSymbol = "SCN1A", orgDb = "org.Hs.eg.db", 
        txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene", feature = transcripts) 
    expect_s4_class(variants, "DataFrame")
    expect_equal(dim(variants), c(8547, 33))
})

test_that("searchVariantsByGeneSymbol feature=exons works", {
    skip_on_bioc()
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariantsByGeneSymbol(host = host, 
        variantSetId = variantSetId, seqlevelsStyle = "NCBI",
        geneSymbol = "A1BG", orgDb = "org.Hs.eg.db",
        txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene", feature = exons) 
    expect_s4_class(variants, "DataFrame")
    expect_equal(dim(variants), c(140, 24))
})

test_that("searchVariantsByGeneSymbol feature=cds works", {
    skip_on_bioc()
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariantsByGeneSymbol(host = host, 
        variantSetId = variantSetId,seqlevelsStyle = "NCBI", geneSymbol = "SCN1A", 
        "org.Hs.eg.db", "TxDb.Hsapiens.UCSC.hg19.knownGene", feature = cds) 
    expect_s4_class(variants, "DataFrame")
    expect_equal(dim(variants), c(124, 24))
})

test_that("searchVariantsByGeneSymbol feature=promoters works", {
    skip_on_bioc()
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariantsByGeneSymbol(host = host, 
        variantSetId = variantSetId,seqlevelsStyle = "NCBI", geneSymbol = "SCN1A", 
        "org.Hs.eg.db", "TxDb.Hsapiens.UCSC.hg19.knownGene", feature = promoters) 
    expect_s4_class(variants, "DataFrame")
    expect_equal(dim(variants), c(177, 24))
})

test_that("searchVariantsByGeneSymbol multiple genes works", {
    skip_on_bioc()
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariantsByGeneSymbol(host = host, 
        variantSetId = variantSetId,seqlevelsStyle = "NCBI",
        geneSymbol = c("A1BG", "SCN1A"), orgDb = "org.Hs.eg.db",
        txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene") 
    expect_s4_class(variants, "DataFrame")
    expect_equal(dim(variants), c(4770, 34))
})

test_that("searchVariantsByGeneSymbol multiple genes feature=transcripts works", {
    skip_on_bioc()
    host <- "http://1kgenomes.ga4gh.org/"
    datasetId <- searchDatasets(host, nrows = 1)$id
    variantSetId <- searchVariantSets(host, datasetId, nrows = 1)$id
    variants <- searchVariantsByGeneSymbol(host = host, 
        variantSetId = variantSetId,seqlevelsStyle = "NCBI",
        geneSymbol = c("A1BG", "SCN1A"), orgDb = "org.Hs.eg.db",
        txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene", feature = transcripts) 
    expect_s4_class(variants, "DataFrame")
    expect_equal(dim(variants), c(9263, 34))
})